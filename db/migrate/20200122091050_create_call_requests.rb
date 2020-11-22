class CreateCallRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :call_requests do |t|
      t.string :name
      t.string :phone_number
      t.string :call_time
      t.string :max_budget
      t.text :description
      t.boolean :complete , default: false
      t.timestamps
    end
  end
end
