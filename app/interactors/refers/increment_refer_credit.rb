module Refers
  class IncrementReferCredit
    include Interactor

    def call
      refer = Refer.find_by(key: context.key)
      user = refer.owner
      credit = user.credit
      credit.value = credit.value + context.free_credit
      credit.save
    end
  end
end