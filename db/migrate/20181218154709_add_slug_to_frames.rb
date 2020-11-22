class AddSlugToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :slug, :string
  end
end
