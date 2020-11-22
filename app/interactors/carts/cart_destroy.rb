module Carts
  class CartDestroy
    include Interactor

    def call
      Rw::Authorize.call(context.user, CartPolicy, :destroy_cart?)
      Cart.where(id: context.id).delete_all
    end
  end
end