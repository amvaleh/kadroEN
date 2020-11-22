class RemoveExpertisIdInShootTypes < ActiveRecord::Migration[5.0]
  def change
    remove_column :shoot_types,:expertise_id
  end
end
