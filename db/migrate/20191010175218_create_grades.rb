class CreateGrades < ActiveRecord::Migration[5.0]
  def change
    create_table :grades do |t|
      t.string :title
      t.string :fa_title

      t.timestamps
    end
  end
end
