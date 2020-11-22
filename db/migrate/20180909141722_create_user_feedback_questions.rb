class CreateUserFeedbackQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_feedback_questions do |t|
      t.integer :feedback_question_id
      t.integer :user_feedback_id
      t.integer :value
      t.timestamps
    end
  end
end
