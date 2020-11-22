class EmailProjectSubmitted
  include Sidekiq::Worker

  def perform(slug)
    puts "slug=" + slug.to_s
    OrderMailer.order_recieved(slug).deliver_now
  end
end
