class CreatePhotographyTools < ActiveRecord::Migration[5.0]
  def change
    create_table :photography_tools do |t|
      t.string :name
      t.timestamps
    end
  end
end
