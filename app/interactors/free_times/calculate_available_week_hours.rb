module FreeTimes
  class CalculateAvailableWeekHours
    include Interactor

    def call
      free_times = FreeTime.where(photographer_id: context.photographer_id)
      total = 0
      free_times.each do |free_time|
        total = total + free_time.end.hour - free_time.start.hour
      end
      context.available_hours = total
    end
  end
end
