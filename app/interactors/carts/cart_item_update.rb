module CartItems
  class CartItemUpdate
    include Interactor

    def call
      Rw::Authorize.call(context.user, CartPolicy, :update?)
      cart_item = Rw::Panel::CartItem.find(context.id)
      cart_item_form = CartItemForm.new(cart_item)
      if cart_item_form.validate(context.cart_item_data)
        cart_item_form.save
      else
        context.cart_item = cart_item_form
        context.fail!
      end
    end
  end
end
