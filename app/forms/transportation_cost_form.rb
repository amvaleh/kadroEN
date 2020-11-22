class TransportationCostForm < Reform::Form
  property :value
  property :receipt_id
  property :active
  property :is_payed

  validates :value, presence: true
  validates :receipt_id, presence: true
end