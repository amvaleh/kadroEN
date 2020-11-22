class AddVideoPosterToVideoSamples < ActiveRecord::Migration[5.0]
  def change
    add_column :video_samples, :video_poster, :string
  end
end
