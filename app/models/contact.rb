class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :contact, class_name: "User"

  validates :contact_id, uniqueness: { scope: :user_id }
  validate :cannot_contact_self

  private

  def cannot_contact_self
    errors.add(:contact_id, "cannot be the same as user") if user_id == contact_id
  end
end
