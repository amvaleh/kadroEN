class AddDownloadedTimesToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :downloaded_times, :integer , default: 0
    add_column :frames, :downloaded, :boolean , default: false
  end
end
