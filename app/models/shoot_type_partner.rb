class ShootTypePartner < ApplicationRecord
  belongs_to :shoot_type
  belongs_to :partner
end
