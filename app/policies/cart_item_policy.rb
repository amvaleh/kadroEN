class CartItemPolicy < Struct.new(:user, :cart_item)
  def cart_item_delete?
    has_cart_item?(user, cart_item)
  end

  private

  def has_cart_item?(user, cart_item)
    CartItem.joins(:cart).where('user_id = ? and cart_items.id = ?', user.id, cart_item.id).count > 0
  end
end