class AddInstagramidToPhotorapher < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :online_portfolio, :string
    add_column :photographers, :instagram, :string
    add_column :photographers, :linkedin, :string
  end
end
