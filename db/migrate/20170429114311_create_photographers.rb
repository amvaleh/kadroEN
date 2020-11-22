class CreatePhotographers < ActiveRecord::Migration[5.0]
  def change
    create_table :photographers do |t|
      t.integer :expertise_id
      t.string :first_name
      t.string :last_name
      t.string :location
      t.string :avatar

      t.timestamps
    end
  end
end
