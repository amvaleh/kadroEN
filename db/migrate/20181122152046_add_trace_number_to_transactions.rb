class AddTraceNumberToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column(:transactions, :trace_number, :string)
  end
end
