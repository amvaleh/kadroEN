module ActiveAdmin
  module ResourcesHelper
    def info_day_type(day , shoot_type)
      @free_timess = []
      if day == 8 && shoot_type == 0
        @free_times = FreeTime.joins(:photographer).where(:photographers => {:approved=>true})
      elsif day == 8
        @free_times = FreeTime.joins(:photographer => :expertises).where( :photographers => {:approved=>true} , :expertises => {:shoot_type_id=>shoot_type , :approved=>true})
      elsif shoot_type == 0
        @free_times = FreeTime.joins(:photographer).where(:day => day , :photographers => {:approved=>true})
      else
        @free_times = FreeTime.joins(:photographer => :expertises).where(:day => day , :photographers => {:approved=>true} , :expertises => {:shoot_type_id=>shoot_type , :approved=>true})
      end
      @free_times.each do |free_time|
        @free_timess << free_time.id
      end
      @ph_counter = 0
      @hours = 0
      while @free_timess.any?
        @free_timess.each do |free_time|
          @ph_counter = @ph_counter + 1
          @local_free_time = @free_times.where(id: free_time)
          @ph_free_times = @free_times.where(:photographer_id => @local_free_time.first.photographer_id)
          @remove_ids = []
          @ph_free_times.each do |ph_free_time|
            @hours = @hours + ((ph_free_time.end - ph_free_time.start) / 1.hour).round
            @remove_ids << ph_free_time.id
          end
          @remove_ids.each do |remove_id|
            @free_timess.delete(remove_id)
          end
        end
      end
      @data = [@hours , @ph_counter]
      return @data
    end
  end
end
