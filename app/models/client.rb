class Client < ActiveRecord::Base
  def write_message(payload)
    WonderQ.write_message(payload)
  end

  def read_messages(count, processing_time_limit)
    WonderQ.read_messages(count, processing_time_limit)
  end

  def mark_processed(message_id)
    WonderQ.mark_processed(message_id)
  end
end
