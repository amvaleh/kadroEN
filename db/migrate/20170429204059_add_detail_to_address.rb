class AddDetailToAddress < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :detail, :text
  end
end
