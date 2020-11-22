class AddErrorsToPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    add_column(:photographer_payments, :errors, :string)
  end
end
