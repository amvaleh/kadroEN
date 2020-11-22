class CartForm < Reform::Form
  property :user_id
  property :date_time
  property :status

  validates :user_id, presence: true
  validates :status, presence: true
end