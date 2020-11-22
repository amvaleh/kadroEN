module Projects
  #this Interactor updates project prices after changing ph successfully.
  class UpdateProjectPrices
    include Interactor

    def call
      @project = Project.find(context.project_id)
      price = context.price
      old_price = context.old_price
      receipt = @project.receipt

      @project.set_reserve_step("wating_for_ph")
      @project.save

      # Here we update photographer payments if photographer has been changed thus photographer_payments should be updated.
      payments = PhotographerPayment.where(project_id: @project.id).load

      unless payments.where(payment_type: 4).any? or price == 0
        result = PhotographerPayments::PhotographerPaymentCreate.call(data: {photographer_id: @project.photographer_id,
                                                                             project_id: @project.id,
                                                                             price: price,
                                                                             status: 2,
                                                                             payment_type: 4})
      end

      payments.each do |p|
        # if payment is about transportation cost of photographer then update it.
        if p.payment_type == 4
          result = PhotographerPayments::PhotographerPaymentUpdate.call(
              id: p.id,
              photographer_payment_data: {photographer_id: @project.photographer_id, price: price})
        else
          result = PhotographerPayments::PhotographerPaymentUpdate.call(
              id: p.id,
              photographer_payment_data: {photographer_id: @project.photographer_id})
        end
        if result.success?
          result = true
        else
          result = false
        end
      end

      receipt.transportion_cost = price
      receipt.total = receipt.total.to_f + price.to_f - old_price.to_f
      receipt.subtotal = receipt.subtotal.to_f + price.to_f - old_price.to_f

      if receipt.save
        if defined? result
          if result
            context.success = true
          end
        else
          context.success = true
        end
      end

    end
  end
end