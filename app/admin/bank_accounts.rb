ActiveAdmin.register BankAccount do
  menu parent: "Photographer", priority: 21
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :card_name, :card_last_name, :card_number, :shaba, :bank_name, :photographer_id, :photographer

  before_action :log_activities, only: [:update, :destroy]
  controller do
    def log_activities
      current_admin_user.create_activity action_name, owner: current_admin_user, recipient: BankAccount.find(params[:id])
    end
  end

  index :title => "اطلاعات بانکی عکاسان" do
    selectable_column
    column :id
    column :photographer
    column :card_number
    column :shaba
    column :card_name
    column :card_last_name
    column :bank_name
    actions
  end

  form do |f|
    f.inputs "Information" do
      # f.input :photographer, :as => :select, :collection => Photographer.approved.all.sort_by { |e| e[:first_name] }.sort_by { |a| a.approved ? 0 : 1 }.map { |u| [u.display_name + u.pointer, u.id] }
      f.input :card_number
      f.input :shaba
      f.input :card_name
      f.input :card_last_name
      f.input :bank_name
    end
    f.actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
