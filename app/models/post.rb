class Post < ApplicationRecord
  belongs_to :user

  validates :title, :body, :category, presence: true
end
