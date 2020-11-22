class Refer < ApplicationRecord
  belongs_to :owner, polymorphic: true
  after_create :generate_key


  def generate_key
    self.key = generate_code
    self.save
  end

  def generate_code
    loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      raw_string = SecureRandom.random_number( 2**80 ).to_s( 20 ).reverse
      long_code = raw_string.tr( '0123456789abcdefghij', '234679QWERTYUPADFGHX' )
      short_code = long_code[0..2] + '-' + long_code[4..6]
      break short_code.downcase! unless (Refer.exists?(key: short_code) and Coupon.exists?(code: short_code))
    end
  end
end
