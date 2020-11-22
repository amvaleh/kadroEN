class AddRateToPhotographer < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :qrate, :float , default: 0
    add_column :photographers, :arate, :float , default: 0
  end
end
