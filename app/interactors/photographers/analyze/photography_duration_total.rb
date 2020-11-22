module Photographers::Analyze
  class PhotographyDurationTotal
    include Interactor

    def call
      context.total_time = Project.payed.joins(:package)
                               .where('photographer_id = ?', context.photographer_id)
                               .sum("case
         when duration = 'هفت ساعت' then 7
         when duration = 'سه ساعت' then 3
         when duration = 'دو ساعت' then 2
         when duration = 'یک ساعت' then 1
         else 0
           end")
    end
  end
end