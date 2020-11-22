module GoodFeedbacks
  class SearchGoodFeedbacksWithLimit
    include Interactor

    QUERY = <<-SQL
    select *
    from good_feedbacks
    limit ?
    SQL

    def call
      context.good_feedbacks = GoodFeedback.find_by_sql([QUERY, context.limit])
    end
  end
end
