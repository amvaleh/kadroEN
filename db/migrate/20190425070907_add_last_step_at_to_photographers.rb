class AddLastStepAtToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :last_step_at, :datetime
  end
end
