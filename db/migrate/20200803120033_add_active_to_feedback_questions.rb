class AddActiveToFeedbackQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :feedback_questions, :active, :boolean , default: true
  end
end
