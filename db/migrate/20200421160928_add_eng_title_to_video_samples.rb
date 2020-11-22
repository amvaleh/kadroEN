class AddEngTitleToVideoSamples < ActiveRecord::Migration[5.0]
  def change
    add_column :video_samples, :eng_title, :string
  end
end
