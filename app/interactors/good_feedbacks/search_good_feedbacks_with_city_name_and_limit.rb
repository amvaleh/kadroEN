module GoodFeedbacks
  class SearchGoodFeedbacksWithCityNameAndLimit
    include Interactor

    QUERY = <<-SQL
    select *
    from good_feedbacks
    where name = ?
    limit ?
    SQL

    def call
      context.good_feedbacks = GoodFeedback.find_by_sql([QUERY, context.city_name, context.limit])
    end
  end
end
