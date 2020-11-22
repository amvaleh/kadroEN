class CreateFeedbackQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :feedback_questions do |t|
      t.string :question_type
      t.string :name
      t.string :question_title
      t.text :question
      t.timestamps
    end
  end
end
