class WidgetType < ApplicationRecord
  has_many :widgets , dependent: :delete_all
  validates :name, presence: true
end
