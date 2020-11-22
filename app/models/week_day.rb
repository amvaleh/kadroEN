class WeekDay < ApplicationRecord
  has_many :start_hours
  has_many :projects


  def self.priority_order
    order("
        CASE
          WHEN id = '8' THEN '1'
          WHEN id = '1' THEN '2'
          WHEN id = '2' THEN '3'
          WHEN id = '3' THEN '4'
          WHEN id = '4' THEN '5'
          WHEN id = '5' THEN '6'
          WHEN id = '6' THEN '7'
          WHEN id = '7' THEN '8'
        END")
  end
end
