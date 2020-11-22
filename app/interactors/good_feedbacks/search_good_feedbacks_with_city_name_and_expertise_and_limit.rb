module GoodFeedbacks
  class SearchGoodFeedbacksWithCityNameAndExpertiseAndLimit
    include Interactor

    QUERY = <<-SQL
    select *
    from good_feedbacks
    where name = ? and title = ?
    limit ?
    SQL

    def call
      context.good_feedbacks = GoodFeedback.find_by_sql([QUERY,context.city_name, context.shoot_type_name, context.limit])
    end
  end
end
