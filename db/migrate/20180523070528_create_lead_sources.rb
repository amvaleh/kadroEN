class CreateLeadSources < ActiveRecord::Migration[5.0]
  def change
    create_table :lead_sources do |t|
      t.string :title
      t.string :description
      t.integer :refers , default: 0
      t.timestamps
    end
    add_column :users, :lead_source_id, :integer
  end
end
