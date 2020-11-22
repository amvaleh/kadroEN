class AddImageSecureTokenToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :image_secure_token, :string
  end
end
