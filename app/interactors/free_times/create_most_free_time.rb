module FreeTimes
  class CreateMostFreeTime
    include Interactor
    include ApplicationHelper

    def call
      @photographer = context.photographer
      for i in 1..7
        free_time = @photographer.free_times.build(day: i, start: Date.today.beginning_of_day.to_time + 11.hours,
                                                   end:Date.today.beginning_of_day.to_time + 26.hours )
        free_time.save
      end
      context.success = true
    end
  end
end
