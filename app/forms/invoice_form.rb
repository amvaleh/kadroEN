class InvoiceForm < Reform::Form
  property :vch_number
  property :cart_id
  property :coupon_id
  property :address_id
  property :status
  property :track_code
  property :authority

  validates :vch_number, presence: true
  validates :cart_id, presence: true
  validates :status, presence: true
end
