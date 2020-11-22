class SentPhotographerEmail < ApplicationRecord
  # attr_accessible :name, :email, :sent , :photographer_id
  belongs_to :photographer
  has_many :sent_photographer_email_opens
  scope :opened, -> { where(opened: true) }

end
