module Invoices
  class InvoiceCreate
    include Interactor
    
    def call
      coupon_id = Coupon.where(value: context.data[:coupon]).pluck(:id)[0]

      invoice = Invoice.find_by(cart_id: context.data[:cart_id])
      if invoice
        invoice_form = InvoiceForm.new(invoice)
      else
        invoice_form = InvoiceForm.new(Invoice.new)
      end
      # invoice_form = InvoiceForm.new(Invoice.new)
      if invoice_form.validate(vch_number: context.data[:vch_number],
                               cart_id: context.data[:cart_id],
                               address_id: context.data[:address_id],
                               coupon_id: coupon_id,
                               status: context.data[:status])
        invoice_form.save

        create_invoice_items(invoice_form)

        # update_cart(current_cart)

        context.invoice = invoice_form
      else
        context.invoice = invoice_form
        context.fail!
      end
    end

    private

    def create_invoice_items(invoice_form)
      current_cart = Carts::CurrentCartItems.call(user: context.user).result
      current_cart.each do |c|
        invoice_item = InvoiceItem.find_by(cart_item_id: c.id)
        if invoice_item
          invoice_item_form = InvoiceItemForm.new(invoice_item)
        else
          invoice_item_form = InvoiceItemForm.new(InvoiceItem.new)
        end
        # invoice_item_form = InvoiceItemForm.new(InvoiceItem.new)
        if invoice_item_form.validate(invoice_id: invoice_form.id,
                                      cart_item_id: c.id,
                                      unit_price: c.price,
                                      price: c.quantity * c.price,
                                      quantity: c.quantity)
          invoice_item_form.save
        end
      end
      current_cart
    end

    def update_cart(current_cart)
      cart = CartForm.new(Cart.find_by(id: current_cart[0].cart_id))
      if cart.validate(status: 1)
        cart.save
      end
    end
  end
end