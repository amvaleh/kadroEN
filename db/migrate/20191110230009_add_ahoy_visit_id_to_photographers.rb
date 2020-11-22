class AddAhoyVisitIdToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :ahoy_visit_id, :bigint
  end
end
