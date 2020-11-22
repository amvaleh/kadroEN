class AddIdeasUrlToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :ideas_url, :string
  end
end
