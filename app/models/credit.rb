class Credit < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :credit_details
end
