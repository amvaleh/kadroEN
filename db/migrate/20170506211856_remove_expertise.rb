class RemoveExpertise < ActiveRecord::Migration[5.0]
  def change
    remove_column :photographers , :expertise_id
  end
end
