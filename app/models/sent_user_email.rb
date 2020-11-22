class SentUserEmail < ApplicationRecord
  belongs_to :user
  has_many :sent_user_email_opens
  scope :opened, -> { where(opened: true) }
end
