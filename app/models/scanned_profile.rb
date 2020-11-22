class ScannedProfile < ApplicationRecord
  # validates :birthـcertificate, presence: true
  # validates :national_card, presence: true

  belongs_to :photographer
  mount_uploader :birthـcertificate, ScannedProfileUploader
  mount_uploader :national_card, ScannedProfileUploader
end
