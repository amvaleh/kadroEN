class CallStatus < ApplicationRecord
  has_one :project
  has_one :photographer
end
