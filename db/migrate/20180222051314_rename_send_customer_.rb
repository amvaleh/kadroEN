class RenameSendCustomer < ActiveRecord::Migration[5.0]
  def change
    rename_column :projects, :send_coustomer, :send_customer
    rename_column :projects, :extera_download, :extra_download
  end
end
