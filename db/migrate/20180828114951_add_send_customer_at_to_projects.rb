class AddSendCustomerAtToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :send_customer_at, :datetime
  end
end
