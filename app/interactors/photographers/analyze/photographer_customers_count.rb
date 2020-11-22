module Photographers::Analyze
  class PhotographerCustomersCount
    include Interactor

    def call
      context.customers_number = Project.confirmed.select(:user_id).distinct.where('photographer_id = ?',context.photographer_id).count
    end
  end
end