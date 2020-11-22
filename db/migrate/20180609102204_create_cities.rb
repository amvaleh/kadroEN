class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :eng_name
      t.string :description
      t.timestamps
    end
  end
end
