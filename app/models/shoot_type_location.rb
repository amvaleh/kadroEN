class ShootTypeLocation < ApplicationRecord
  belongs_to :shoot_location
  belongs_to :shoot_type
end
