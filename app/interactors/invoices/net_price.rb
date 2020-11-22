module Invoices
  class NetPrice
    include Interactor

    def call
      context.result = InvoiceItem.where(invoice_id: context.invoice_id).sum(:price)
    end
  end
end