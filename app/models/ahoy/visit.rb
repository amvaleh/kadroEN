class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true
  has_one :project, foreign_key: :ahoy_visit_id

  def technology
    [browser, os, device_type].map(&:presence).compact.join(", ")
  end

  def location
    [city, region, country].map(&:presence).compact.join(", ")
  end

  scope :visits_with_date_and_utm_source, ->(start_date, end_date, utm_source) { where("started_at >= ? and started_at <= ? and utm_source = ?", start_date.to_date.to_time, end_date.to_date.to_time, utm_source) }
end
