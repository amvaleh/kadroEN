class CouponShootType < ApplicationRecord
  belongs_to :coupon
  belongs_to :shoot_type
end
