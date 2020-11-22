class InvoicesController < ApplicationController
  layout :resolve_layout

  def resolve_layout
    case action_name
    when "do_pay_form"
      "gallery"
    when "do_pay_form_dashboard"
      "dashboard"
    else
      "application"
    end
  end

  def invoice_form
    @has_only_download = Invoices::HasOnlyDownload.call(user: current_user).result
    @do_take_address = Invoices::HasOnlyRetouchOrDownload.call(user: current_user).result
    address = Invoices::UserAddress.call(user_id: current_user.id).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    render locals: { address: address, total: total, cart_id: params[:cart_id] }
  end

  def invoice_form_dashboard
    @has_only_download = Invoices::HasOnlyDownload.call(user: current_user).result
    @do_take_address = Invoices::HasOnlyRetouchOrDownload.call(user: current_user).result
    address = Invoices::UserAddress.call(user_id: current_user.id).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    render locals: { address: address, total: total, cart_id: params[:cart_id] }
  end

  def shipping_address_create
    ActiveRecord::Base.transaction do
      result = Invoices::ShippingAddressCreate.call(data: params[:shipping_address])
      if result.success?
        @message = t(:'invoices.messages.success_save')
      else
        @error = t(:'invoices.messages.unknown_error')
      end
    end
  end

  def invoice_create
    ActiveRecord::Base.transaction do
      user_result = Users::UserUpdate.call(id: current_user.id,
                                           user_data: { full_name: params[:shipping_address][:full_name],
                                                        email: params[:shipping_address][:email] })

      if user_result.success?
        has_only_download = Invoices::HasOnlyRetouchOrDownload.call(user: current_user).result
        result = nil
        address_id = nil
        unless has_only_download
          result = Invoices::ShippingAddressCreate.call(data: params[:shipping_address])
          address_id = result.address.id
        end
        if has_only_download || result.success?
          result = Invoices::InvoiceCreate.call(data: { vch_number: Invoices::GenerateVchNumber.call.result,
                                                        cart_id: params[:shipping_address][:cart_id],
                                                        address_id: address_id,
                                                        coupon: params[:shipping_address][:coupon].tr("۰۱۲۳۴۵۶۷۸۹", "0123456789"),
                                                        status: 0 }, user: current_user)
          raise ActiveRecord::Rollback unless result.success?
        else
          @error = t(:'invoices.messages.unknown_error')
          raise ActiveRecord::Rollback
        end

        net_price = Invoices::NetPrice.call(invoice_id: result.invoice.id).result
        # net_price = 1000
        invoice = result.invoice

        if net_price > 99
          if params[:shipping_address][:dashboard] == "true"
            redirect_to controller: "invoices", action: :do_pay_form_dashboard, invoice_id: invoice.id
          else
            redirect_to controller: "invoices", action: :do_pay_form, invoice_id: invoice.id
          end
        end
      end
    end
  end

  def do_pay_form
    @user = current_user

    invoice = Invoices::InvoiceSummary.call(user: current_user, invoice_id: params[:invoice_id]).result
    net_price = Invoices::NetPrice.call(invoice_id: params[:invoice_id]).result
    call_back = if Rails.env.production?
        "https://app.kadro.co/invoices/#{invoice[0].vch_number}/verify_pay?"
      elsif Rails.env.development?
        "http://app.localhost:3000/invoices/#{invoice[0].vch_number}/verify_pay?"
      elsif Rails.env.staging?
        "http://185.53.143.141:3005/invoices/#{invoice[0].vch_number}/verify_pay?"
      end

    context = InvoiceFactors::DestroyInvoiceFactors.call(cart_id: invoice[0].cart_id)

    if context.coupon.present?
      code = context.coupon.code
      result = Factors::CheckCouponFactors.call(cart_id: invoice[0].cart_id, code: code, user: current_user).result
    end

    render locals: { invoice: invoice, net_price: net_price, full_url: call_back, invoice_id: params[:invoice_id], discount_results: result, code: code }

    @user = current_user
    @invoice = Invoice.find_by(id: params[:invoice_id])
    @user.create_activity :created_invoice, owner: @user, recipient: @invoice
  end

  def do_pay_form_dashboard
    @user = current_user

    invoice = Invoices::InvoiceSummary.call(user: current_user, invoice_id: params[:invoice_id]).result
    net_price = Invoices::NetPrice.call(invoice_id: params[:invoice_id]).result
    call_back = if Rails.env.production?
        "https://app.kadro.co/invoices/#{invoice[0].vch_number}/verify_pay?"
      elsif Rails.env.development?
        "http://app.localhost:3000/invoices/#{invoice[0].vch_number}/verify_pay?"
      elsif Rails.env.staging?
        "http://185.53.143.141:3005/invoices/#{invoice[0].vch_number}/verify_pay?"
      end

    context = InvoiceFactors::DestroyInvoiceFactors.call(cart_id: invoice[0].cart_id)

    if context.coupon.present?
      code = context.coupon.code
      result = Factors::CheckCouponFactors.call(cart_id: invoice[0].cart_id, code: code, user: current_user).result
    end

    render locals: { invoice: invoice, net_price: net_price, full_url: call_back, invoice_id: params[:invoice_id], discount_results: result, code: code }

    @user = current_user
    @invoice = Invoice.find_by(id: params[:invoice_id])
    @user.create_activity :created_invoice, owner: @user, recipient: @invoice
  end

  def verify_pay
    if params[:status] == "nok"
      redirect_to controller: :galleries, result: "nok"
    elsif params[:vch_number]
      validation = Transactions::ValidateUpdate.call(trace_number: params[:track_code])
      if validation.success?
        invoice = Invoice.find_by(vch_number: params[:vch_number])
        if params[:track_code]
          # This line is for test only, do not uncomment it.
          # params[:track_code] = 10011
          ActiveRecord::Base.transaction do
            Invoices::UpdateAfterVerify.call(user: current_user, ref_id: params[:track_code], invoice: invoice)
            Invoices::FrameDownloadPermission.call(invoice_id: invoice.id)
            Invoices::UpdateReceipt.call(invoice_id: invoice.id)
            PhotographerPayments::InvoicePayments.call(invoice_id: invoice.id)
            Invoices::ShopOrderDetails.call(invoice_id: invoice.id)

            coupon = InvoiceItem.joins(invoice_factor: :factor).
              select("factors.coupon_id").
              where("invoice_items.invoice_id = ?", invoice.id).take(1)[0]
            if coupon
              a_coupon = Coupon.find_by(id: coupon.coupon_id)
              a_coupon.used_times += 1
              a_coupon.save
            end

            if params[:credit] == "true"
              credit = current_user.credit
              credit_detail_type = CreditDetailType.find_by(english_name: "use_in_shop")
              Credits::CheckCreditUsage.call(credit: credit, usage_amount: credit.value, credit_detail_type: credit_detail_type)
            end
          end

          short_url = Shortener::ShortenedUrl.generate("/invoice_show?track_code=#{params[:track_code]}")
          SuccessPaymentWorker.perform_async(
            current_user.id,
            "http://l.kadro.co/#{short_url.unique_key}",
            "فاکتور فروش", params[:track_code]
          )
          Invoices::SuccessSms.call(mobile_number: current_user.mobile_number,
                                    link: "http://l.kadro.co/#{short_url.unique_key}",
                                    track_code: params[:track_code])
          current_user.create_activity :payed_invoice, owner: current_user, recipient: invoice
          gallery = Galleries::GalleryByInvoice.call(invoice: invoice).result
          if gallery.id.present?
            gallery = Gallery.find(gallery.id)
            redirect_to "/galleries/#{gallery.slug}?result=ok&track_code=#{params[:track_code]}"
          else
            redirect_to controller: :galleries, result: "ok", track_code: params[:track_code]
          end
        else
          redirect_to controller: :galleries, result: "nok"
        end
      else
        current_user.create_activity :not_success_invoice_pay, owner: current_user
        redirect_to controller: :galleries, result: "nok"
      end
    end
  end

  def payment_result
    if params[:result] == "ok"
      @res = t(:'invoices.messages.success_payment')
      @track_code = params[:ref_id]
    else
      @res = t(:'invoices.messages.failed_payment')
    end
  end

  def invoice_show
    invoice = Invoices::InvoiceShow.call(user: current_user, track_code: params[:track_code]).result
    frames = Carts::CurrentFrames.call(frame_ids: invoice.map { |c| c.frame_id }).result
    net_price = Invoices::NetPrice.call(invoice_id: invoice[0].id).result
    render locals: { invoice: invoice, frames: frames, net_price: net_price }
  end

  def create_zip
    Rw::Authorize.call(current_admin_user, InvoicePolicy, :create_zip?)
    result = Invoices::CreateZip.call(order_id: params[:id], order_type: params[:order_type])
    if result.success?
      if params[:order_type].to_i == 1
        send_file("#{Rails.root}/print_orders/cart_#{params[:id]}.zip")
      else
        send_file("#{Rails.root}/print_orders/invoice_#{params[:id]}.zip")
      end
    else
      redirect_to :back
    end
  end

  def show_cart
    cart_items = Carts::CurrentCartItems.call(cart_id: params[:cart_id])
  end

  def check_coupon
    context = Factors::CheckCouponFactors.call(cart_id: params[:cart_id], code: params[:code], user: current_user)

    if context.result[:response] == "ok"
      invoice = Cart.find(params[:cart_id]).invoice
      current_user.create_activity :use_invoice_coupon, owner: current_user, recipient: invoice
    end

    render json: context.result.to_json
  end

  def delete_coupon
    context = InvoiceFactors::DestroyInvoiceFactors.call(cart_id: params[:cart_id])

    if context.result[:response] == "ok"
      invoice = Cart.find(params[:cart_id]).invoice
      current_user.create_activity :remove_invoice_coupon, owner: current_user, recipient: invoice
    end

    render json: context.result.to_json
  end

  def zero_payment_invoice
    invoice = Invoice.find(params[:invoice_id])
    ActiveRecord::Base.transaction do
      Invoices::UpdateAfterVerify.call(user: current_user, invoice: invoice)
      Invoices::FrameDownloadPermission.call(invoice_id: invoice.id)
      Invoices::UpdateReceipt.call(invoice_id: invoice.id)
      PhotographerPayments::InvoicePayments.call(invoice_id: invoice.id)
      Invoices::ShopOrderDetails.call(invoice_id: invoice.id)

      coupon = InvoiceItem.joins(invoice_factor: :factor).
        select("factors.coupon_id").
        where("invoice_items.invoice_id = ?", invoice.id).take(1)[0]
      if coupon
        a_coupon = Coupon.find_by(id: coupon.coupon_id)
        a_coupon.used_times += 1
        a_coupon.save
      end

      credit = current_user.credit
      credit_detail_type = CreditDetailType.find_by(english_name: "use_in_shop")
      Credits::CheckCreditUsage.call(credit: credit, usage_amount: params[:credit_usage].to_i, credit_detail_type: credit_detail_type)
    end

    redirect_to controller: :galleries, action: "complete_project", result: "ok_without_payment"
  end
end
