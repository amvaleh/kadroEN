class ExpertiseWidget < ApplicationRecord
  has_many :expertise_widget_attachments , dependent: :delete_all
  accepts_nested_attributes_for :expertise_widget_attachments
  belongs_to :expertise
  belongs_to :widget
  validates :expertise_id, presence: true
  validates :widget_id, presence: true
end
