class AddDescription2ToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :feature_5, :string
    add_column :packages, :feature_6, :string
    add_column :packages, :feature_7, :string
    add_column :packages, :real_price, :string
  end
end
