module Projects
  class SetProjectAsCheckout
    include Interactor

    def call
      projects = Project.joins(:photographer_payments).where("photographer_payments.id in (?) and photographer_payments.payment_type not in (11)", context.ids)

      projects.update_all(reserve_step_id: 17)
      projects.update_all(checked_out: true)
    end
  end
end
