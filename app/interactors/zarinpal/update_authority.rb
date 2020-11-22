module Zarinpal
  class UpdateAuthority
    include Interactor

    def call
      if context.model_name == 'invoice'
        Invoices::InvoiceUpdate.call(id: context.id, invoice_data: {authority: context.authority})
      else

      end
    end
  end
end