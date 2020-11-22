class CreateCredits < ActiveRecord::Migration[5.0]
  def change
    create_table :credits do |t|
      t.float :value
      t.references :owner, polymorphic: true

      t.timestamps
    end
  end
end
