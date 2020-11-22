class CreateJoinSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :join_steps do |t|
      t.string :name
      t.timestamps
    end
  end
end
