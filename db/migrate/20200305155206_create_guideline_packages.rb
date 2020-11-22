class CreateGuidelinePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :guideline_packages do |t|
      t.integer :package_id
      t.integer :guideline_id
      t.timestamps
    end
  end
end