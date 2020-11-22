module Photographers::Analyze
  class PhotographerTotalIncome
    include Interactor

    def call
      context.total_income = Project.payed.joins(:receipt)
                                 .where('photographer_id = ?',context.photographer_id).sum('CAST(ph_payment as FLOAT)')
    end

  end
end