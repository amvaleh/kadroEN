class AddShortenedUrlIdToGalleries < ActiveRecord::Migration[5.0]
  def change
    add_column :galleries, :shortened_url_id, :integer
  end
end
