require "spec_helper"

describe WonderQ do
  before do
    @client_one = Client.create
    @client_two = Client.create
    @payload = { "data" => "Test data" }
    @processing_time_limit = 1.day
  end

  context "when a client writes to it" do
    it "saves the message to the db with the correct payload" do
      @client_one.write_message(@payload)

      expect(Message.count).to eq(1)
      expect(JSON.parse(Message.first.payload)).to eq(@payload)
    end

    it "generates a message ID and returns it" do
      response = @client_one.write_message(@payload)

      expect(Message.first.id).not_to be(nil)
      expect(Message.first.id).to eq(response)
    end
  end

  it "allows multiple clients to write to it" do
    @client_one.write_message(@payload)
    @client_two.write_message(@payload)

    expect(Message.count).to eq(2)
  end

  context "when a client polls for new messages" do
    before do
      5.times { @client_one.write_message(@payload) }
      @number_of_messages_requested = 5
    end

    it "receives the number of messages requested" do
      messages = @client_one.read_messages(@number_of_messages_requested, @processing_time_limit)

      expect(messages.length).to be(5)
    end

    it "gets those messages which are not processed by any other consumer" do
      other_client_requested_messages = @client_two.read_messages(1, @processing_time_limit)
      messages = @client_one.read_messages(@number_of_messages_requested, @processing_time_limit)

      expect(messages.length).to be(4)
      expect(messages.map(&:id)).not_to include(other_client_requested_messages.first.id)
    end
  end

  it "allows multiple clients to poll from it" do
    @client_one.write_message(@payload)
    @client_two.write_message(@payload)
    messages_batch_one = @client_one.read_messages(1, @processing_time_limit)
    messages_batch_two = @client_two.read_messages(1, @processing_time_limit)

    expect(messages_batch_one).not_to be(nil)
    expect(messages_batch_two).not_to be(nil)
  end

  context "when a consumer notifies WonderQ that it has processed a message" do
    it "deletes the message from the WonderQ database" do
      message_id = @client_one.write_message(@payload)
      @client_one.read_messages(1, @processing_time_limit)
      @client_one.mark_processed(message_id)

      expect(Message.where(:id => message_id).count).to be(0)
    end
  end

  context "when a consumer does NOT notify WonderQ that it has processed a message within the configured amount of time" do
    it "allows the message to remain in the db after the processing time limit has passed" do
      message_id = @client_one.write_message(@payload)
      @client_one.read_messages(1, @processing_time_limit)

      expect(Message.where(:id => message_id).count).to be(1)
    end

    it "makes the message available to any consumer requesting again" do
      message_id = @client_one.write_message(@payload)
      @client_one.read_messages(1, @processing_time_limit)

      Timecop.freeze(DateTime.now.utc + @processing_time_limit) do
        messages_batch_two = @client_two.read_messages(1, @processing_time_limit)
        expect(messages_batch_two.first.id).to eq(message_id)
      end
    end

    it "cannot notify WonderQ that it has processed the message" do
      message_id = @client_one.write_message(@payload)
      @client_one.read_messages(1, @processing_time_limit)

      Timecop.freeze(DateTime.now.utc + @processing_time_limit) do
        @client_two.read_messages(1, @processing_time_limit)
        processed = @client_one.mark_processed(message_id)

        expect(processed).to be(false)
        expect(Message.where(:id => message_id).count).to be(1)
      end
    end
  end
end
