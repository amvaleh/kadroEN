class CreateExperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :experiences do |t|
      t.integer :photographer_id
      t.integer :years_been_photographer , default: 0
      t.boolean :has_payed_work , default: false
      t.integer :projects_payed_count , default: 0
      t.text :self_describe
      t.text :bio
      t.text :passion
      t.text :love_job
      t.text :favorite_shoots
      t.text :shoots
      t.text :city_shoots
      t.text :awards
      t.text :fun_fact

      t.timestamps
    end
  end
end
