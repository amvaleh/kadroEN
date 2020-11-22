class AddPaymentByCreditToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :payment_by_credit, :boolean, default: false
  end
end
