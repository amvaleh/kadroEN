class AddOrderToExpertises < ActiveRecord::Migration[5.0]
  def change
    add_column :expertises, :order, :integer
  end
end
