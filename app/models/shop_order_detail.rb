class ShopOrderDetail < ApplicationRecord
  belongs_to :photographer
  belongs_to :invoice_item

end
