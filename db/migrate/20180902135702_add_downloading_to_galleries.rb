class AddDownloadingToGalleries < ActiveRecord::Migration[5.0]
  def change
    add_column :galleries, :downloading_zip, :boolean , default: false
  end
end
