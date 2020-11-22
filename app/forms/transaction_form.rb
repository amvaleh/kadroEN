class TransactionForm < Reform::Form
  property :email
  property :afterwards_url
  property :mobile_number
  property :amount
  property :slug
  property :message
  property :description
  property :status
  property :track_number
  property :locked
  property :trace_number
  property :access_token

  validates :afterwards_url, presence: true
  validates :slug, presence: true
  validates_uniqueness_of :slug
end
