class SentPhotographerEmailOpen < ApplicationRecord
  # attr_accessible :name, :email, :ip_address, :opened , :sent_photographer_email_id
  belongs_to :sent_photographer_email
end
