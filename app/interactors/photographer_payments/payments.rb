module PhotographerPayments
  class Payments
    include Interactor

    QUERY = <<-SQL
      select sum(price) price, photographer_id
      from photographer_payments
      where cashout_id is null and status = 2
      group by photographer_id;
    SQL

    def call
      context.result = PhotographerPayment.find_by_sql([QUERY])

    end
  end
end