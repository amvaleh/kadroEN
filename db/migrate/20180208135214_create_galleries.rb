class CreateGalleries < ActiveRecord::Migration[5.0]
  def change
    create_table :galleries do |t|
      t.integer :project_id
      t.string :slug

      t.timestamps
    end
  end
end
