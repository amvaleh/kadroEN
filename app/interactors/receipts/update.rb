module Receipts
  class Update
    include Interactor

    def call
      receipt = Receipt.find_by(id: context.id)
      receipt = ReceiptForm.new(receipt)
      if receipt.validate(context.data)
        receipt.save
        context.receipt = receipt
      else
        context.receipt = receipt
        context.fail!
      end
    end
  end
end
