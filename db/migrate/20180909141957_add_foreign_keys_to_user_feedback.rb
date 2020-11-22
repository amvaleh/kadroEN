class AddForeignKeysToUserFeedback < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key(:user_feedback_questions, :user_feedbacks, column: :user_feedback_id, index: true)
    add_foreign_key(:user_feedback_questions, :feedback_questions, column: :feedback_question_id, index: true)
  end
end
