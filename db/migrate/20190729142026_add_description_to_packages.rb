class AddDescriptionToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :description, :text
    add_column :packages, :feature_1, :string
    add_column :packages, :feature_2, :string
    add_column :packages, :feature_3, :string
    add_column :packages, :feature_4, :string
    add_column :packages, :vip, :boolean
    add_column :packages, :vip_url, :string
    add_column :packages, :name, :string
  end
end
