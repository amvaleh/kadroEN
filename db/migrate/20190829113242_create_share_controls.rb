class CreateShareControls < ActiveRecord::Migration[5.0]
  def change
    create_table :share_controls do |t|
      t.boolean :permit , default: false
      t.string :title

      t.timestamps
    end
  end
end
