class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :cart_item
  has_one :invoice_factor
  has_one :shop_order_detail
end
