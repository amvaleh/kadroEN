class ItemType < ApplicationRecord
  has_many :items , dependent: :destroy
  belongs_to :commission
end
