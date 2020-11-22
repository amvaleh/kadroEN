class CreatePartners < ActiveRecord::Migration[5.0]
  def change
    create_table :partners do |t|
      t.string :title
      t.text :service
      t.string :website
      t.integer :click_counter , default: 0
      t.string :avatar

      t.timestamps
    end
  end
end
