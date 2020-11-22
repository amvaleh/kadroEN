class AddExpertiseIdToPhotos < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :expertise_id, :integer
  end
end
