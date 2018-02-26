class WonderQ
  def self.write_message(payload)
    message = Message.create(:payload => payload.to_json)
    message.id
  end

  def self.read_messages(count, processing_time_limit, client_id)
    self.check_for_overdue_messages(processing_time_limit)
    messages = Message.where(:being_read => false).last(count)
    begin
      messages.each do |message|
        message.read_at = Time.now.utc
        message.being_read = true
        message.reader_id = client_id
        message.save!
      end
    rescue
      false
    end
    messages
  end

  def self.mark_processed(message_id, client_id)
    message = Message.find(message_id)
    if message.being_read && message.reader_id == client_id
      message.destroy
    else
      false
    end
  end

  private

  def self.check_for_overdue_messages(processing_time_limit)
    overdue_messages = Message.where(:being_read => true).where("read_at < ?", processing_time_limit.ago)
    overdue_messages.each do |msg|
      msg.being_read = false
      msg.save!
    end
  end
end
