class CreateWidgets < ActiveRecord::Migration[5.0]
  def change
    create_table :widgets do |t|
      t.integer :widget_type_id
      t.string :name
      t.string :description
      t.boolean :approved, default: true
      t.timestamps
    end
  end
end
