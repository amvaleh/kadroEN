class TransactionsController < ApplicationController
  require "uri"
  require "net/http"

  def initial_send
    payment_gateway = Setting.find_by(var: "payment_gateway").value
    description = params[:transaction][:description]
    email = params[:transaction][:email]
    mobile_number = params[:transaction][:mobile_number]
    afterwards_url = params[:transaction][:afterwards_url]
    amount = if payment_gateway == "zarinpal"
        params[:transaction][:amount].to_i
      elsif payment_gateway == "pay.ir" || payment_gateway == "vandar.io" || payment_gateway == "jibit.ir"
        params[:transaction][:amount].to_i * 10
      end

    if amount == 0
      credit_usage = params[:transaction][:credit_usage]
      if params[:transaction][:type] == "extra-payment"
        redirect_to controller: "projects", action: "verify_pay", id: params[:transaction][:model_id], zero_payment: true, credit_usage: credit_usage and return
      elsif params[:transaction][:type] == "reserve-payment"
        redirect_to afterwards_url + "zero_payment=true&credit_usage=" + credit_usage.to_s and return
      elsif params[:transaction][:type] == "invoice-payment"
        invoice_id = params[:transaction][:model_id]
        redirect_to controller: "invoices", action: "zero_payment_invoice", invoice_id: invoice_id, credit_usage: credit_usage and return
      end
    end

    # create new transaction
    random_token = ""
    loop do
      random_token = SecureRandom.urlsafe_base64(5, false)
      break random_token unless Transaction.exists?(slug: random_token)
    end
    transaction = Transactions::TransactionCreate.call(data: { email: email, description: description, amount: amount, afterwards_url: afterwards_url, mobile_number: mobile_number, slug: random_token })
    if payment_gateway == "zarinpal"
      call_back = if Rails.env.production?
          "https://app.kadro.co/transactions/do_verify"
        elsif Rails.env.development?
          "http://app.localhost:3000/transactions/do_verify"
        elsif Rails.env.staging?
          "http://185.53.143.141:3005/transactions/do_verify"
        end
      result = Zarinpal::Pay.call(net_price: amount,
                                  email: email,
                                  mobile_number: mobile_number,
                                  call_back: call_back,
                                  description: description)
      if result.success?
        # Zarinpal::UpdateAuthority.call(model_name: params[:transaction][:model],
        #                                id: params[:transaction][:model_id], authority: result.authority)
        Transactions::TransactionUpdate.call(slug: transaction.transaction.slug, data: { track_number: result.authority,
                                                                                         status: result.status })
        @user = User.find_by(mobile_number: mobile_number)
        @user.create_activity :bank_gateway, owner: @user

        redirect_to "https://www.zarinpal.com/pg/StartPay/#{result.authority}/sep"
      else
        Transactions::TransactionUpdate.call(slug: transaction.transaction.slug,
                                             data: { track_number: result.authority,
                                                     status: result.status, message: "ERROR" })
        redirect_to :back, alert: "تراکنش با درگاه ساخته نشده است."
      end
    elsif payment_gateway == "pay.ir"
      if transaction.success?
        result = Transactions::InitiateBankGateway.call(slug: transaction.transaction.slug)
        if result.success?
          @user = User.find_by(mobile_number: mobile_number)
          @user.create_activity :bank_gateway, owner: @user

          redirect_to "https://pay.ir/payment/gateway/#{result.track_number}"
        else
          redirect_to :back, alert: "تراکنش با درگاه ساخته نشده است."
        end
      else
        redirect_to :back, alert: "تراکنش نمی تواند شروع شود."
      end
    elsif payment_gateway == "jibit.ir"
      call_back = if Rails.env.production?
          "https://app.kadro.co/transactions/do_verify"
        elsif Rails.env.development?
          "http://app.localhost:3000/transactions/do_verify"
        elsif Rails.env.staging?
          "http://185.53.143.141:3005/transactions/do_verify"
        end
      result = Jibit::Pay.call(net_price: amount,
                               email: email,
                               mobile_number: mobile_number,
                               call_back: call_back,
                               description: description,
                               slug: transaction.transaction.slug)
      if result.success?
        # Zarinpal::UpdateAuthority.call(model_name: params[:transaction][:model],
        #                                id: params[:transaction][:model_id], authority: result.authority)
        Transactions::TransactionUpdate.call(slug: transaction.transaction.slug, data: { track_number: result.authority,
                                                                                         status: "100",
                                                                                         access_token: result.access_token })
        @user = User.find_by(mobile_number: mobile_number)
        @user.create_activity :bank_gateway, owner: @user

        redirect_to result.psp_switching_url
      else
        Transactions::TransactionUpdate.call(slug: transaction.transaction.slug,
                                             data: { track_number: result.authority,
                                                     status: result.status, message: "ERROR" })
        redirect_to :back, alert: "تراکنش با درگاه ساخته نشده است."
      end
    end

    # make post request and send it
    # get result and check it
    # redirect user to destination
    # change this in API V1 too
  end

  def nailedit
    # find transaction and update it
    status = params["status"]
    transaction_id = params["transId"]
    transaction = Transaction.where(track_number: transaction_id).last
    updated = Transactions::TransactionUpdate.call(slug: transaction.slug,
                                                   data: { trace_number: params["traceNumber"],
                                                           status: status, message: params["message"] })
    # Verify the transaction and redirect user to the afterwards_url
    if updated.success?
      if status == "1"
        result = Transactions::Verify.call(trans_id: params["transId"])
        if result.success?
          redirect_to (updated.transaction.afterwards_url + "track_code=#{updated.transaction.trace_number}")
        else
          redirect_to (updated.transaction.afterwards_url + "status=nok&message=#{updated.transaction.message}")
        end
      else
        redirect_to (updated.transaction.afterwards_url + "status=nok&message=#{updated.transaction.message}")
      end
    else
      redirect_to (updated.transaction.afterwards_url + "status=nok&message=cantupdate!")
    end
  end

  def do_verify
    if params[:state].present?
      transaction_id = params["refnum"]
      transaction = Transaction.where(track_number: transaction_id).last
      if params[:state] == "SUCCESSFUL"
        result = Jibit::Verify.call(net_price: transaction.amount, authority: params[:refnum], access_token: transaction.access_token)
        if result.success?
          updated = Transactions::TransactionUpdate.call(slug: transaction.slug,
                                                         data: { trace_number: result.ref_id,
                                                                 status: "1" })
          redirect_to (updated.transaction.afterwards_url + "track_code=#{result.ref_id}")
        end
      elsif params[:state] == "FAILED" || params[:state] == "Unknown"
        message = "تراکنش با خطا مواجه شد"
        updated = Transactions::TransactionUpdate.call(slug: transaction.slug, data: { status: params[:state] })
        redirect_to (updated.transaction.afterwards_url + "status=nok&message=#{message}")
      end
    else
      status = params["Status"]
      transaction_id = params["Authority"]
      transaction = Transaction.where(track_number: transaction_id).last
      if status == "OK"
        result = Zarinpal::Verify.call(net_price: transaction.amount, authority: params[:Authority])
        if result.success?
          updated = Transactions::TransactionUpdate.call(slug: transaction.slug,
                                                         data: { trace_number: result.ref_id,
                                                                 status: "1" })
          redirect_to (updated.transaction.afterwards_url + "track_code=#{result.ref_id}")
        end
      elsif status == "NOK"
        message = "تراکنش با خطا مواجه شد"
        updated = Transactions::TransactionUpdate.call(slug: transaction.slug, data: { status: "NOK" })
        redirect_to (updated.transaction.afterwards_url + "status=nok&message=#{message}")
      end
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:afterwards_url, :email, :mobile_number, :amount, :slug, :message,
                                        :description, :status, :track_number, :trace_number)
  end
end
