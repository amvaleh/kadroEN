class AddExtraCreditToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :extra_credit, :integer, default: 0
  end
end
