module Transactions
  class TransactionUpdate
    include Interactor

    def call
      trns = Transaction.find_by(slug: context.slug)
      transaction = TransactionForm.new(trns)
      if transaction.validate(context.data)
        transaction.save
        context.transaction = transaction
      else
        context.transaction = transaction
        context.fail!
      end
    end
  end
end
