module Carts
  class CartParentCreate
    include Interactor

    def call
      a_cart = Cart.find_by(user_id: context.user.id, status: 0)
      if a_cart
        context.cart = CartForm.new(a_cart)
      else
        cart = CartForm.new(Cart.new)
        if cart.validate(context.cart_data)
          cart.save
          context.cart = cart
        else
          context.cart = cart
          context.fail!
        end
      end
    end
  end
end
