module Invoices
  class TotalProfit
    include Interactor
    QUERY = <<-SQL
    select sum((it.price - it.cost)*ci.quantity) sum
    from 
    (select *
    from invoices pp
    where pp.created_at >= ? and pp.created_at <= ? and pp.status = 1) i
    left join carts c on c.id = i.cart_id
    right join cart_items ci on ci.cart_id = c.id
    left join items it on it.id = ci.item_id
    where c.id is not null and ci.quantity > 0
            SQL

    def call
      invoices = Invoice.find_by_sql([QUERY, context.start_date, context.end_date])
      context.total = invoices.map { |r| r.sum }.first.to_i
    end
  end
end
