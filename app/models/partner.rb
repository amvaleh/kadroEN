class Partner < ApplicationRecord
  has_many :shoot_type_partners
  has_many :shoot_types , through: :shoot_type_partners
  mount_uploader :avatar, AvatarUploader

end
