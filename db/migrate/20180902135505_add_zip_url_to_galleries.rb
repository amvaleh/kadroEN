class AddZipUrlToGalleries < ActiveRecord::Migration[5.0]
  def change
    add_column :galleries, :zip_url, :string
  end
end
