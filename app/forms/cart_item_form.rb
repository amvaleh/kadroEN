class CartItemForm < Reform::Form
  property :item_id
  property :frame_id
  property :project_id
  property :cart_id
  property :quantity
  property :item_type, virtual: true

  validates :item_id, presence: true
  validates :frame_id, presence: true
  validates :project_id, presence: true
  validates :cart_id, presence: true
  validates :quantity, presence: true
  validate :validate_quantity

  def validate_quantity
    item = Item.joins(:item_type).where('items.id = ? and item_types.category = ?', item_id, 'download').take(1)[0]
    if item && quantity.to_i > 1
      errors.add(:quantity, I18n.t(:'carts.messages.download_quantity'))
    end
  end
end