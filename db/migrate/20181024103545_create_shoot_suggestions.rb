class CreateShootSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :shoot_suggestions do |t|
      t.integer :photographer_id
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
