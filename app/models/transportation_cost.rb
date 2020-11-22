class TransportationCost < ApplicationRecord
  belongs_to :receipt



  scope :payed, -> {
    where(:is_payed => true)
  }

  scope :active, -> {
    where(:active => true)
  }
end
