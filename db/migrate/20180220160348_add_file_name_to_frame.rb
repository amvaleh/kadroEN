class AddFileNameToFrame < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :file_name, :string
    add_column :frames, :format, :string
    add_column :frames, :type, :string
    add_column :frames, :signature, :string
  end
end
