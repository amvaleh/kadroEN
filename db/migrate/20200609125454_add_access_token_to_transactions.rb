class AddAccessTokenToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :access_token, :string
  end
end
