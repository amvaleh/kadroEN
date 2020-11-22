class CreateExpertises < ActiveRecord::Migration[5.0]
  def change
    create_table :expertises do |t|
      t.integer :shoot_type_id
      t.integer :photographer_id

      t.timestamps
    end
  end
end
