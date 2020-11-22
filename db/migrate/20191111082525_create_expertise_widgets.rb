class CreateExpertiseWidgets < ActiveRecord::Migration[5.0]
  def change
    create_table :expertise_widgets do |t|
      t.integer :expertise_id
      t.integer :widget_id
      t.string :description
      t.boolean :approved, default: true
      t.timestamps
    end
  end
end
