module Credits
  class CheckCreditUsage
    include Interactor

    def call
      credit = context.credit
      credit_detail_type = context.credit_detail_type
      usage = context.usage_amount
      credit_detail = CreditDetail.new(credit_id: credit.id, value: -(usage), credit_detail_type_id: credit_detail_type.id)
      credit_detail.save
      # credit.value = credit.value - usage
      #
      # credit.save
    end
  end
end