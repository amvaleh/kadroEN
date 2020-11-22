class AddZipCreatedAtToGalleries < ActiveRecord::Migration[5.0]
  def change
    add_column :galleries, :zip_created_at, :datetime
  end
end
