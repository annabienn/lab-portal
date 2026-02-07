class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contacts = current_user.contacts.includes(:contact).order(created_at: :desc)
  end

  def create
    email = params[:email].to_s.strip.downcase
    user = User.find_by("LOWER(email) = ?", email)

    if user.nil?
      redirect_to contacts_path, alert: "Δεν βρέθηκε χρήστης με αυτό το email."
      return
    end

    contact = current_user.contacts.build(contact: user)

    if contact.save
      redirect_to contacts_path, notice: "Η επαφή προστέθηκε."
    else
      redirect_to contacts_path, alert: contact.errors.full_messages.to_sentence
    end
  end

  def destroy
    contact = current_user.contacts.find(params[:id])
    contact.destroy
    redirect_to contacts_path, notice: "Η επαφή αφαιρέθηκε."
  end
end
