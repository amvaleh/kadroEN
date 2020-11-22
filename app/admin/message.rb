ActiveAdmin.register Message do
  permit_params :mobile_number, :body
  menu priority: 7

  controller do
    before_filter do
      if params[:message].present? && action_name != "new"
        sms_message = params[:message][:body]
        mobile_number = params[:message][:mobile_number]

        res = SmsWorker.perform_async(sms_message, mobile_number)

        if res
          redirect_to admin_messages_path
        end
      end
    end
  end

  index do
    column :id
    column :mobile_number
    column "body" do |m|
      div style: 'direction: rtl !important' do
        m.body
      end
    end
    column :created_at
    actions
  end
  form do |f|
    f.inputs 'Messages' do
      f.input :mobile_number
      f.input :body
    end
    f.actions
  end
end
