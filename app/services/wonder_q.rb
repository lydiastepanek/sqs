class WonderQ
  def initialize
  end

  def write_message(payload)
    message = Message.create(payload)
    message.id
  end

  def read_messages(count)
    messages = Message.last(count)
  end

  def mark_processed(message_id)
    message = Message.find(message_id)
    message.destroy
  end
end
