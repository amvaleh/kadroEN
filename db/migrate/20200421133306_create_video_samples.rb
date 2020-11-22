class CreateVideoSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :video_samples do |t|
      t.string :title
      t.string :video_source
      t.integer :cameras_count
      t.boolean :helishot
      t.boolean :scenario
      t.string :output_length
      t.string :edit_level
      t.string :project_length
      t.string :price

      t.timestamps
    end
  end
end
