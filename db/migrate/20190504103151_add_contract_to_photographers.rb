class AddContractToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :contract, :boolean
  end
end
