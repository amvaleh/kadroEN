module Projects
  class Search
    include Interactor

    def call
      result = Project.joins(:user).
          where("(users.first_name LIKE ? OR users.last_name LIKE ? OR concat(users.first_name, ' ', users.last_name) LIKE ?) and photographer_id = ? and is_payed = ?",
                "%#{context.customer_name.strip}%", "%#{context.customer_name.strip}%", "%#{context.customer_name.strip}%",
                context.photographer_id, true)

      result =
          if context.from_date && context.to_date.nil?
            result.where('start_time >= ?', context.from_date)
          elsif context.from_date.nil? && context.to_date
            result.where('start_time <= ?', context.to_date)
          elsif context.from_date && context.to_date
            result.where('start_time >= ? and start_time <= ?', context.from_date, context.to_date)
          else
            result
          end
      context.result = result
    end
  end
end