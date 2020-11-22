class ShootSuggestion < ApplicationRecord
  belongs_to :photographer
  belongs_to :project
  belongs_to :user
end
