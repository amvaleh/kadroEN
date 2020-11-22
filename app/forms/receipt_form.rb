class ReceiptForm < Reform::Form
  property :total
  property :subtotal
  property :coupon_id
  property :user_id
  property :track_code
  property :filedownload_total
  property :extrahour_total
  property :print_total
  property :ph_payment
  property :extrahour_paid
  property :extrahour_track_code
  property :extra_paid
  property :business_total
  property :business_checkout
end
