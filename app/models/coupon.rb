class Coupon < ApplicationRecord
  attr_accessor :auto_generate

  has_many :receipts
  has_many :projects
  has_many :coupon_shoot_types
  has_many :coupon_redemptions
  has_many :factor
  belongs_to :user

  after_create :generate_coupon_code
  after_save :check_repetitions


  def check_repetitions
    # if self.number_of_repetitions > 1
    #   new_coupon = Coupon.new(title: self.title , value: self.value , is_percent: self.is_percent , is_active: self.is_active , used_times: self.used_times , valid_from: self.valid_from , valid_until: self.valid_until , redemption_limit: self.redemption_limit , number_of_repetitions: 1 , is_first_order: self.is_first_order)
    #   new_coupon.save
    #   self.number_of_repetitions = self.number_of_repetitions - 1
    #   self.save
    # end
    if self.number_of_repetitions > 1
      new_number = 0
      (self.number_of_repetitions - 1).times do |index|
        new_coupon = Coupon.new(title: self.title, value: self.value, is_percent: self.is_percent, is_active: self.is_active, used_times: self.used_times, valid_from: self.valid_from, valid_until: self.valid_until, redemption_limit: self.redemption_limit, number_of_repetitions: 1, is_first_order: self.is_first_order)
        new_coupon.save
        if (self.number_of_repetitions - 2) == index
          new_number = 1
        end
      end
      if new_number == 1
        self.reload
        self.number_of_repetitions = new_number
        self.save
      end
    end
  end

  def generate_coupon_code
    self.code = generate_code
    self.save
  end

  def generate_code
    loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      raw_string = SecureRandom.random_number( 2**80 ).to_s( 20 ).reverse
      long_code = raw_string.tr( '0123456789abcdefghij', '234679QWERTYUPADFGHX' )
      short_code = long_code[0..3] + '-' + long_code[4..7]
      break short_code.downcase! unless (Coupon.exists?(code: short_code) and Refer.exists?(key: short_code))
    end
  end
  scope :is_active , -> {
    where(:is_active => true)
  }
end
