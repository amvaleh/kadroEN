class PhotographerAttachment < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  belongs_to :photographer
end
