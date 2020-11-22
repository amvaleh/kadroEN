desc "days of week statistics"
task :days_of_week_statistics => :environment do
  sat = 0
  sun = 0
  mon = 0
  tue = 0
  wed = 0
  thu = 0
  fri = 0
  total = 0
  Project.all.payed.count
  Project.all.payed.each do |p|
     if p.start_time.present?
       total = total + 1
     puts p.start_time.wday.to_s
     case p.start_time.wday
     when 1
       mon = mon + 1
     when 2
       tue = tue + 1
     when 3
       wed = wed + 1
     when 4
       thu = thu + 1
     when 5
       fri = fri + 1
     when 6
       sat = sat + 1
     when 0
       sun = sun +1
     end
  end
end
puts "mon:" + mon.to_s
puts "tue:" + tue.to_s
puts "wed:" + wed.to_s
puts "thu:" + thu.to_s
puts "fri:" + fri.to_s
puts "sat:" + sat.to_s
puts "sun:" + sun.to_s
jam = 0
jam = sat + sun + mon + tue + wed + thu + fri
puts "total:" + total.to_s + " - " + jam.to_s
end
