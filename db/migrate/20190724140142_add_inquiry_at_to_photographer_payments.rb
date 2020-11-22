class AddInquiryAtToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :photographer_payments, :inquiry_at, :datetime
  end
end
