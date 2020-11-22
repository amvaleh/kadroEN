class AddEnglishNameToCreditDetailTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :credit_detail_types, :english_name, :string
  end
end
