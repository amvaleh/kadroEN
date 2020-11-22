class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item
  belongs_to :photo
  belongs_to :project
  belongs_to :frame
  has_one :invoice_item
end
