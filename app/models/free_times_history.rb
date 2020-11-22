class FreeTimesHistory < ApplicationRecord
  belongs_to :photographer
  default_scope -> { order(created_at: :desc) }
end
