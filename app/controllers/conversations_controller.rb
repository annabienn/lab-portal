class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations.includes(:users).order(updated_at: :desc)
    @contacts = current_user.contact_users.order(:email)
  end

  def show
    @conversation = current_user.conversations.find(params[:id])
    @message = Message.new
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
  end

  def create
    participant_ids = Array(params[:participant_ids]).reject(&:blank?).map(&:to_i).uniq
    participant_ids << current_user.id
    participant_ids.uniq!

    if participant_ids.length < 2
      redirect_to conversations_path, alert: "Επίλεξε τουλάχιστον έναν χρήστη."
      return
    end

    conversation = Conversation.new(title: params[:title].to_s.strip.presence)
    conversation.users = User.where(id: participant_ids)

    if conversation.save
      redirect_to conversation_path(conversation), notice: "Η συνομιλία δημιουργήθηκε."
    else
      redirect_to conversations_path, alert: conversation.errors.full_messages.to_sentence
    end
  end
end
