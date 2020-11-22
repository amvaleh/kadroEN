class SentProjectEmail < ApplicationRecord
  belongs_to :project
  has_many :sent_project_email_opens
  scope :opened, -> { where(opened: true) }
end
