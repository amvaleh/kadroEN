class InvoiceFactor < ApplicationRecord
  belongs_to :invoice_item
  belongs_to :factor
end
