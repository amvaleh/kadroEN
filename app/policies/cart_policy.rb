class CartPolicy < Struct.new(:user, :cart)
  def index?
    user.admin? || user.support?
  end

  def destroy_cart?
    user.admin? || user.support?
  end

  def cart_datatable?
    user.admin? || user.support?
  end

  def create?
    user.admin? || user.support? || user.user?
  end

  def update?
    (user.admin? || user.support? || (user.cart_manager && has_cart?(user, cart)))
  end

  private

  def has_cart?(user, cart)
    Cart.where('user_id = ? and id = ?', user.id, cart.id).count > 0
  end
end