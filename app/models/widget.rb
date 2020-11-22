class Widget < ApplicationRecord
  has_many :expertise_widgets , dependent: :delete_all
  belongs_to :widget_type
  validates :name, presence: true
end
