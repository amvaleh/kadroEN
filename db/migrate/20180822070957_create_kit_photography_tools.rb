class CreateKitPhotographyTools < ActiveRecord::Migration[5.0]
  def change
    create_table :kit_photography_tools do |t|
      t.integer :photography_tool_id
      t.integer :kit_id
      t.integer :count
      t.timestamps
    end
  end
end
