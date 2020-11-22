module InvoiceFactors
  class DestroyInvoiceFactors
    include Interactor

    def call
      if context.cart_id
        invoice_items = Cart.find(context.cart_id).invoice.invoice_items
      elsif context.cart_item_id
        invoice_items = InvoiceItem.where(cart_item_id: context.cart_item_id)
      end

      had = false

      invoice_items.each do |invoice_item|
        if invoice_item.invoice_factor.present?
          context.coupon = invoice_item.invoice_factor.factor.coupon
          invoice_item.invoice_factor.destroy
          had = true
        end
      end
      if had
        context.result = {response: 'ok', message: "با موفقیت حذف شد.", invoice_items: invoice_items}
      else
        context.result = {response: 'error'}
      end
    end
  end
end