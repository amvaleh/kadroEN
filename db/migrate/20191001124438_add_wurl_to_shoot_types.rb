class AddWurlToShootTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :shoot_types, :w_url, :string
    add_column :shoot_types, :w_title, :string
    add_column :shoot_types, :w_subtitle, :string
  end
end
