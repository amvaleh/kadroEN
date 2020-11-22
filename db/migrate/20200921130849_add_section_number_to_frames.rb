class AddSectionNumberToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :section_number, :integer
  end
end
