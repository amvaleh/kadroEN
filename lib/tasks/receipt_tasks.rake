namespace :receipt_tasks do
  desc "calculate ph share for old projects"
  task calculate_ph_payment: :environment do
    Project.payed.each do |project|
      payment = 0
      receipt = project.receipt
      # if project.package.present?
      # payment = project.package.price
      # else
      payment = receipt.total.to_i
      # end
      if receipt.filedownload_total.to_i > 0
        payment = payment + receipt.filedownload_total.to_i
      end
      if receipt.extrahour_total.to_i > 0
        payment = payment + receipt.extrahour_total.to_i
      end
      total_payment = payment * 0.9
      total_payment = total_payment.to_i.to_s
      receipt.ph_payment = total_payment
      puts receipt.ph_payment
      receipt.save
    end
  end

  desc "calculate_extrahour_paid"
  task calculate_extrahour_paid: :environment do
    receipts = []
    Receipt.all.each do |receipt|
      if receipt.extrahour_total > 0
        receipts << receipt
      end
    end
    if receipts.any?
      receipts.each do |receipt|
        receipt.extrahour_paid = receipt.extrahour_total
        receipt.save
      end
    end
  end


  desc 'update reserve_step for old projects'
  task set_reserve_step: :environment do
    Project.all.where(:is_payed=>true).each do |project|
      puts project.id
      if project.checked_out
        project.set_reserve_step("checkout")
      elsif project.send_customer
        project.set_reserve_step("checkout")
      elsif project.has_gallery
        project.set_reserve_step("uploaded")
      elsif project.passed_72hour
        project.set_reserve_step("confirmed")
      elsif project.confirmed
        project.set_reserve_step("confirmed")
      else
        project.set_reserve_step("wating_for_ph")
      end
      project.save
    end
  end



end
