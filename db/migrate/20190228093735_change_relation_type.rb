class ChangeRelationType < ActiveRecord::Migration[5.0]
  def up
    change_column :factor_items, :relation_type, :string
  end

  def down
    change_column :factor_items, :relation_type, :integer
  end
end
