class ChangeErrorsInPhotographerPayments < ActiveRecord::Migration[5.0]
  def change
    rename_column(:photographer_payments, :errors, :error_messages)
  end
end
