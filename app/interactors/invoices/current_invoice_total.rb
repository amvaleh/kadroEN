module Invoices
  class CurrentInvoiceTotal
    include Interactor
    def call
      if context.invoice
        context.invoice_total = Invoice.joins(:invoice_items).where('
          invoice_items.invoice_id = ? and status = ?', context.invoice.id, context.status).sum('price')
      end
    end
  end
end
