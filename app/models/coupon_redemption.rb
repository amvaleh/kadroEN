class CouponRedemption < ApplicationRecord
  belongs_to :user
  belongs_to :receipt
  belongs_to :coupon
  before_save :check_first_order

  def check_first_order
    if self.coupon.is_first_order
      if Project.payed.where(user: self.user).any?
        errors.add(:base, "این کد تخفیف برای سفارش اول قابل استفاده است.")
        throw(:abort)
      end
    end
  end
end
