module Api::V1::FreeTimesHelper
  def order_to_duration(order_recieved)
    case order_recieved
    when 1
        1.hour
      when 2
        2.hours
      when 3
        3.hours
      when 4
        4.hours
      when 5
        5.hours
      when 6
        6.hours
      when 7
        7.hours
    end
  end
end
