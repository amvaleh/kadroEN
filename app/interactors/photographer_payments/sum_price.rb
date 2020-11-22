module PhotographerPayments
  class SumPrice
    include Interactor

    def call
      sum_price = PhotographerPayment.where('id in (?)', context.ids).sum(:price)

      context.sum_price = sum_price
    end
  end
end