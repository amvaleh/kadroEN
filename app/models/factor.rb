class Factor < ApplicationRecord
  belongs_to :coupon
  has_many :factor_items
  has_many :invoice_factor
end
