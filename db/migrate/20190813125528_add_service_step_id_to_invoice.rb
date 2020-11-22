class AddServiceStepIdToInvoice < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :service_step_id, :integer
  end
end
