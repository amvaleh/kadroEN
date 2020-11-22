class CreateLocationTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :location_types do |t|
      t.string :title
      t.timestamps
    end
  end
end
