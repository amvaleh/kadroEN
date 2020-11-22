module Invoices
  class CurrentInvoiceCost
    include Interactor
    def call
      if context.invoice
        sum = 0
        invoice = Invoice.find(context.invoice.id)
        invoice.cart.cart_items.each do |ci|
          sum = sum + ci.item.cost
        end
      end
      context.invoice_total = sum
    end
  end
end
