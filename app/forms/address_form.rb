class AddressForm < Reform::Form
  property :longtitude
  property :lattitude
  property :input
  property :detail
  property :phone_number
  property :postal_code

  validates :detail, presence: true
  validates :phone_number, presence: true
  validates :postal_code, presence: true
end