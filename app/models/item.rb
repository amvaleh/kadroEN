class Item < ApplicationRecord
  belongs_to :item_type
  has_many :factor_items, as: :relation

  scope :active, -> {
    where(:status => true)
  }
end
