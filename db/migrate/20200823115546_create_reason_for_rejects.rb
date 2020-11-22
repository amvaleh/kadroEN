class CreateReasonForRejects < ActiveRecord::Migration[5.0]
  def change
    create_table :reason_for_rejects do |t|
      t.string :name
      t.string :user_notice
      t.boolean :have_penalty
      t.timestamps
    end
  end
end
