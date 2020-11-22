class AddIsPayedAtToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :is_payed_at, :datetime
  end
end
