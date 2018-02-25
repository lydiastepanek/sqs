class MessagesController < ApplicationController
  def create
    message = Message.new
    if message.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:product_options)
  end
end
