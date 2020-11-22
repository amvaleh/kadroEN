module Projects
  class ExtraHourDetails
    include Interactor

    def call
      @project = context.project
      receipt = @project.receipt

      extra_hour_details = Projects::CalculateExtraHours.call(project_id: @project.id)
      hours_added = extra_hour_details.hours_added
      cost_to_add = extra_hour_details.cost_to_add
      new_frames = extra_hour_details.new_frames

      # ph_commission=((Setting.find_by_var("photographer_extra_hour_commission").value.to_i).to_f/100)

      extra_old = receipt.extrahour_total
      extrahour_total = (cost_to_add) + extra_old

      amount = extrahour_total - receipt.extrahour_paid
      ph_commission = ((Setting.find_by_var("photographer_extra_hour_commission").value.to_i).to_f / 100)

      @project.extra_hour_requested = 0
      @project.extend_hours = @project.extend_hours + hours_added
      unless @project.package.is_full
        @project.extra_download = @project.extra_download + new_frames.to_i
      end
      @project.save

      context.hours_added = hours_added
      context.amount = amount
      context.ph_commission = ph_commission
      context.extrahour_total = extrahour_total
      context.new_frames = new_frames
    end
  end
end
