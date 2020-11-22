class AddSamplesStringToExpertise < ActiveRecord::Migration[5.0]
  def change
    add_column :expertises, :samples, :string
  end
end
