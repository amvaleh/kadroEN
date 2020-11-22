class AddCallStatusIdToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :call_status_id, :integer
  end
end
