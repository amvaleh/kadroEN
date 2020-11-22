class AddUserShareAndPhShareToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :photographer_share, :integer , default: 0
    add_column :businesses, :user_share, :integer , default: 0
  end
end
