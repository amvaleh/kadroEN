module Transactions
  class TransactionCreate
    include Interactor

    def call
      transaction = TransactionForm.new(Transaction.new)
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
