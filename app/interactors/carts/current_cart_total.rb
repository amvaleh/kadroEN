module Carts
  class CurrentCartTotal
    include Interactor

    def call
      context.item_total = CartItem.joins(:cart).joins(:item).
          where('carts.user_id = ? and frame_id = ? and carts.status = 0',
                context.user.id, context.frame_id).sum('price * quantity')
      context.cart_count = CartItem.joins(:cart).joins(:item).
          where('carts.user_id = ? and carts.status = 0',
                context.user.id).sum('quantity')
      if context.cart_id
        context.cart_total = CartItem.joins(:cart).joins(:item).
            where('carts.user_id = ? and carts.status = 0 and carts.id = ?',
                  context.user.id, context.cart_id).sum('price * quantity')
      else
        context.cart_total = CartItem.joins(:cart).joins(:item).
            where('carts.user_id = ? and carts.status = 0',
                  context.user.id).sum('price * quantity')
      end
    end
  end
end
