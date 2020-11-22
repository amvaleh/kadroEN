class AddInterviewDateToPhotographers < ActiveRecord::Migration[5.0]
  def change
    add_column :photographers, :interview_date, :datetime
  end
end
