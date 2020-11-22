module GoodFeedbacks
  class SearchGoodFeedbacksWithExpertiseAndLimit
    include Interactor

    QUERY = <<-SQL
    select *
    from good_feedbacks
    where title = ?
    limit ?
    SQL

    def call
      context.good_feedbacks = GoodFeedback.find_by_sql([QUERY, context.shoot_type_name, context.limit])
    end
  end
end
