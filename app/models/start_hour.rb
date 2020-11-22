class StartHour < ApplicationRecord
  belongs_to :week_day
  has_many :projects
  belongs_to :day_time


  scope :morning, -> { where(day_time_id: 1) }
  scope :afternoon, -> { where(day_time_id: 2) }
  scope :evening, -> { where(day_time_id: 3) }

end
