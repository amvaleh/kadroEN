class AddRetouchedToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :retouched, :boolean , default: false
  end
end
