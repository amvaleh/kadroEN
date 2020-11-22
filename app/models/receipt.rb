class Receipt < ApplicationRecord
  include PublicActivity::Model

  attr_accessor :admin_user

  has_one :project
  has_one :coupon_redemption
  has_many :transportation_costs

  belongs_to :user
  belongs_to :coupon

  after_update :log_activity

  def log_activity
    if self.admin_user.present?
      self.create_activity key: "admin_update", owner: AdminUser.find(self.admin_user), recipient_type: self.changes.except(:updated_at)
    end
  end

  def calculate_ph_payment(total, commision, discount_city)
    value = total - discount_city
    if commision == 0
      value = total - discount_city
    else
      value = (total - discount_city) * (commision.to_f / 100)
    end
    return value.to_i
  end
end
