module GoodFeedbacks
  class SearchGoodFeedbacksWithPhotographerIdAndLimit
    include Interactor

    QUERY = <<-SQL
    select *
    from good_feedbacks
    where photographer_id = ?
    limit ?
    SQL

    def call
      context.good_feedbacks = GoodFeedback.find_by_sql([QUERY, context.photographer_id, context.limit])
    end
  end
end
