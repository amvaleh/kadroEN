class CreatePhotographerPermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :photographer_permissions do |t|
      t.string :name_of_model
      t.string :name_of_action
      t.integer :photographer_id
      t.boolean :access

      t.timestamps
    end
    add_foreign_key(:photographer_permissions, :photographers, column: :photographer_id, index: true)
    add_index(:photographer_permissions, [:name_of_model, :name_of_action, :photographer_id],
              name: :photographer_permissions_u_index, unique: true)
  end
end
