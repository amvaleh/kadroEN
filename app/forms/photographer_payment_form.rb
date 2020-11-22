class PhotographerPaymentForm < Reform::Form
  property :photographer_id
  property :project_id
  property :price
  property :status
  property :payment_type
  property :payment_date
  property :description
  property :cashout_id
  property :error_messages
  property :deposit_referrer
  property :track_code
  property :invoice_id
  property :checkout_request_at
  property :inquiry_at
  property :bank_gateway_id
  property :jibit_uid

  validates :photographer_id, presence: true
  validates :project_id, presence: true
  validates :price, presence: true
  validates :status, presence: true
  validates :payment_type, presence: true
  validate :track_code_unique?

  private

  def track_code_unique?
    return if track_code.nil? || PhotographerPayment.where("track_code = ? and id <> ?", track_code, id).count == 0
    errors.add(:track_code, I18n.t(:'activerecord.errors.models.photographer_payment.attributes.track_code.taken'))
  end
end
