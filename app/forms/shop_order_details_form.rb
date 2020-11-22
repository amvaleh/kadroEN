class ShopOrderDetailsForm < Reform::Form
  property :photographer_id
  property :invoice_item_id
  property :subtotal

  validates :photographer_id, presence: true
  validates :invoice_item_id, presence: true
  validates :subtotal, presence: true
end