class EmailProjectOrderRecievedWorker
  include Sidekiq::Worker

  def perform(project_id)
    OrderMailer.order_recieved(project_id).deliver_now
  end
end
