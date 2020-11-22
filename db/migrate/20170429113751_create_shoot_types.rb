class CreateShootTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :shoot_types do |t|
      t.string :title
      t.string :avatar
      t.integer :expertise_id

      t.timestamps
    end
  end
end
