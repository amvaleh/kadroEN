module Admins
  class SelectTopAdmins
    include Interactor

    QUERY = <<-SQL
      select l.* , CASE WHEN i.count is null THEN '0' ELSE i.count END AS count
      from admin_users l
      full join 
      (select admin_user_id , count(p.id) as count
      from projects p
      where p.confirmed = true and p.is_payed_at >= ? and p.is_payed_at <= ?
      GROUP BY p.admin_user_id HAVING p.admin_user_id is not null
      ORDER BY count desc
      limit ?) i on i.admin_user_id = l.id
      where count > 0
      ORDER BY count desc

      SQL

    def call
      context.admins = AdminUser.find_by_sql([QUERY, context.start_date, context.end_date, context.limit])
    end
  end
end
