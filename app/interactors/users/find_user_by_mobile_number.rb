module Users
  class FindUserByMobileNumber
    include Interactor

    QUERY = <<-SQL
      select *
      from users u
      where u.mobile_number like ?
      limit 10
      SQL

    def call
      context.users = User.find_by_sql([QUERY, context.mobile_number + "%"])
    end
  end
end
