class CreateUserFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_feedbacks do |t|
      t.integer :project_id
      t.integer :photographer_id
      t.string :description
      t.timestamps
    end
    add_foreign_key(:user_feedbacks, :projects, column: :project_id, index: true)
    add_foreign_key(:user_feedbacks, :photographers, column: :photographer_id, index: true)
  end
end
