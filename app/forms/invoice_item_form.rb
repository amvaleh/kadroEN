class InvoiceItemForm < Reform::Form
  property :invoice_id
  property :cart_item_id
  property :unit_price
  property :price
  property :quantity

  validates :invoice_id, presence: true
  validates :cart_item_id, presence: true
  validates :unit_price, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
end