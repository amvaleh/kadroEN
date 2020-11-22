class ShootLocationAttachment < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :shoot_location
end
