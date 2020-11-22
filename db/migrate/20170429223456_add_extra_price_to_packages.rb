class AddExtraPriceToPackages < ActiveRecord::Migration[5.0]
  def change
    remove_column :packages, :exta_price
    add_column :packages, :extra_price, :string
  end
end
