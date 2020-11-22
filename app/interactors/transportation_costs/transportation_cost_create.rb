module TransportationCosts
  class TransportationCostCreate
    include Interactor

    def call
      transportation_cost = TransportationCostForm.new(TransportationCost.new)
      if transportation_cost.validate(context.data)
        transportation_cost.save
        context.transportation_cost = transportation_cost
      else
        context.transportation_cost = transportation_cost
        context.fail!
      end
    end
  end
end
