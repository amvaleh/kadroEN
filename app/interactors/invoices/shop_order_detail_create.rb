module Invoices
  class ShopOrderDetailCreate
    include Interactor

    def call
      shop_details_form = ShopOrderDetailsForm.new(ShopOrderDetail.new)
      if shop_details_form.validate(context.data)
        shop_details_form.save
        context.shop_order_details = shop_details_form
      else
        context.shop_order_details = shop_details_form
        context.fail!
      end
    end
  end
end