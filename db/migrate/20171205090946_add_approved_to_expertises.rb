class AddApprovedToExpertises < ActiveRecord::Migration[5.0]
  def change
    add_column :expertises, :approved, :boolean , default: false
  end
end
