module Projects
  class CalculateBusinessShare
    include Interactor
    def call
      project = context.project
      receipt = project.receipt
      if project.user.business.present?
        profit = project.package.price.to_f *  ((100 - project.package.photographer_commission).to_f/100)
        receipt.business_total = (profit * (project.user.business.user_share)/100).to_i
        receipt.business_checkout = false
        receipt.save
      end
    end
  end
end
