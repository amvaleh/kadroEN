class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  belongs_to :user
  has_one :invoice

  scope :two_weeks_ago , -> {
    where(:created_at =>(14.days.ago)..(Date.today.end_of_day))
  }

end
