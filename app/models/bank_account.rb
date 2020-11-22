class BankAccount < ApplicationRecord
  belongs_to :photographer
  validate :validate_shaba


  def validate_shaba
    if self.shaba.empty?
      errors.add(:shaba, I18n.t('bank_account.messages.not_present'))
    elsif self.shaba.to_s.length < 24
      errors.add(:shaba, I18n.t('bank_account.messages.short_code'))
    elsif self.shaba.to_s.length > 24
      errors.add(:shaba, I18n.t('bank_account.messages.long_code'))
    elsif !is_i?
      errors.add(:shaba, I18n.t('bank_account.messages.string'))
    end
  end

  def is_i?
    !!(self.shaba =~ /\A[-+]?[0-9]+\z/)
  end
end
