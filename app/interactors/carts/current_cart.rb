module Carts
  class CurrentCart
    include Interactor

    def call
      context.result = CartItem.joins(:cart).
          where('carts.user_id = ? and frame_id = ? and status = 0',
                context.user.id, context.frame_id).load
    end
  end
end