class AddIsPayedToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :is_payed, :boolean , default: false
  end
end
