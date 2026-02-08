class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    conversation = current_user.conversations.find(params[:conversation_id])
    message = conversation.messages.build(message_params.merge(user: current_user))

    if message.save
      MessagesChannel.broadcast_to(
        conversation,
        html: render_message(message),
        sender_id: current_user.id
      )
      broadcast_popup(conversation, message)
      create_notifications(conversation, message)
      head :no_content
    else
      redirect_to conversation_path(conversation), alert: message.errors.full_messages.to_sentence
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def render_message(message)
    ApplicationController.render(
      partial: "messages/message",
      locals: { message: message, current_user_id: message.user_id }
    )
  end

  def broadcast_popup(conversation, message)
    preview = ActionController::Base.helpers.truncate(message.body.to_s, length: 120)
    recipients = conversation.users.where.not(id: message.user_id)
    recipients.find_each do |recipient|
      PopupMessagesChannel.broadcast_to(
        recipient,
        sender: message.user.email,
        body: preview,
        conversation_path: Rails.application.routes.url_helpers.conversation_path(conversation)
      )
    end
  end

  def create_notifications(conversation, message)
    recipients = conversation.users.where.not(id: message.user_id)
    recipients.find_each do |recipient|
      notification = recipient.notifications.create(
        message: "New message from #{message.user.email}",
        link: Rails.application.routes.url_helpers.conversation_path(conversation)
      )
      NotificationsChannel.broadcast_to(
        recipient,
        message: notification.message,
        link: notification.link
      )
    end
  end
end
