class CreateFrames < ActiveRecord::Migration[5.0]
  def change
    create_table :frames do |t|
      t.integer :gallery_id
      t.string :public_id
      t.string :tag

      t.timestamps
    end
  end
end
