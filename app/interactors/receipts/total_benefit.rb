module Receipts
  class TotalBenefit
    include Interactor
    QUERY = <<-SQL
      select sum(cast(r.subtotal as DOUBLE PRECISION) - cast(r.ph_payment as DOUBLE PRECISION) - cast(r.transportion_cost as DOUBLE PRECISION)) sum
      from 
      (select *
      from projects pp
      where pp.is_payed_at >= ? and pp.is_payed_at <= ? and pp.confirmed = true) p
      left join receipts r on r.id = p.receipt_id
          SQL

    def call
      receipts = Receipt.find_by_sql([QUERY, context.start_date, context.end_date])
      context.total = receipts.map { |r| r.sum }.first.to_i
    end
  end
end
