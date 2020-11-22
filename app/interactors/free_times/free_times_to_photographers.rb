module FreeTimes
  class FreeTimesToPhotographers
    include Interactor

    def call
      photographers = []
      context.free_times.each do |free_time|
        photographers << free_time.photographer
      end
      context.photographers = photographers.uniq
    end
  end
end
