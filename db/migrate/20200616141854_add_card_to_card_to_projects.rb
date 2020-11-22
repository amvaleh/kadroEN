class AddCardToCardToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :card_to_card, :boolean
  end
end
