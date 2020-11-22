class AddFirstCallToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :first_call, :boolean
  end
end
