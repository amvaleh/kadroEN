class AddDownloadLimitToGallries < ActiveRecord::Migration[5.0]
  def change
    add_column :galleries, :download_limit, :integer , default: 0
    add_column :galleries, :downloaded_count, :integer , default: 0
  end
end
