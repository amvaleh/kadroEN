module Invoices
  class InvoiceUpdate
    include Interactor

    def call
      invoice_form = InvoiceForm.new(Invoice.find_by(id: context.id))
      if invoice_form.validate(context.invoice_data)
        invoice_form.save
        context.invoice = invoice_form
      else
        context.invoice = invoice_form
        context.fail!
      end
    end
  end
end