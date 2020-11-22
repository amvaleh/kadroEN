class AddStatusToCarts < ActiveRecord::Migration[5.0]
  def change
    add_column(:carts, :status, :integer)
  end
end
