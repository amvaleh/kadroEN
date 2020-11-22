class AddGradeIdToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :grade_id, :integer
  end
end
