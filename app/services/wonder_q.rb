class WonderQ
  def initialize(processing_time_limit)
    @processing_time_limit = processing_time_limit || 1.day
  end

  def write_message(payload)
    message = Message.create(payload)
    message.id
  end

  def read_messages(count)
    overdue_messages = Message.where { |msg| msg.being_read && msg.read_at > @processing_time_limit.ago }
    overdue_messages.all.map { |msg| msg.being_read = false; msg.save! }
    messages = Message.last(count)
    begin
      messages.each do |message|
        message.read_at = Time.now
        message.being_read = true
        message.save!
      end
    rescue
      false
    end
  end

  def mark_processed(message_id)
    remote_message = RemoteMessage.find(message_id)
    remote_message.destroy
  end
end
