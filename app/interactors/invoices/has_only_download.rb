module Invoices
  class HasOnlyDownload
    include Interactor

    def call
      if context.cart_id.present?
        cart_items = Carts::CurrentCartItems.call(cart_id: context.cart_id).result
      else
        cart_items = Carts::CurrentCartItems.call(user: context.user).result
      end
      item = cart_items.select {|ci| ci.category != 'download'}[0]
      context.result = item.nil?
    end
  end
end
