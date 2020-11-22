module Invoices
  class GenerateVchNumber
    include Interactor

    def call
      context.result = Invoice.maximum('cast(vch_number as int)').to_i + 1
    end
  end
end