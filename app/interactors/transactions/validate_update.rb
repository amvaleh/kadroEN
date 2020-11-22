module Transactions
  class ValidateUpdate
    include Interactor

    def call
      transaction = Transaction.find_by(trace_number: context.trace_number)
      if transaction.nil? || transaction.locked || (Time.now - transaction.updated_at_in_gregorian) / 60 > 11
        context.fail!
      else
        Transactions::TransactionUpdate.call(slug: transaction.slug, data: {locked: true})
      end
    end
  end
end