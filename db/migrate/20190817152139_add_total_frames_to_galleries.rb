class AddTotalFramesToGalleries < ActiveRecord::Migration[5.0]
  def change
    add_column :galleries, :total_frames, :integer
  end
end
