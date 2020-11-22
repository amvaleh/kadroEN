class CreateRelevants < ActiveRecord::Migration[5.0]
  def change
    create_table :relevants do |t|
      t.integer :shoot_type_id
      t.string :title

      t.timestamps
    end
  end
end
