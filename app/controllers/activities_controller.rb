class ActivitiesController < ApplicationController
  respond_to :js

  def activities_filter
    @activities = PublicActivity::Activity.all
    if params[:activities].present?
      if params[:activities][:trackable].present?
        trackable_type = params[:activities][:trackable]
      end
      if params[:activities][:key].present?
        action = params[:activities][:key]
      end
      if params[:activities][:recipient].present?
        recipient_type = params[:activities][:recipient]
      end

      if params[:activities][:time].present? and not params[:activities][:time][0] == ""
        date = params[:activities][:time][0].tr('۰۱۲۳۴۵۶۷۸۹','0123456789').split("/")
        time = PDate.new(date[0].to_i,date[1].to_i,date[2].to_i).to_date
      end

      if trackable_type.present?
        @activities = PublicActivity::Activity.where(trackable_type: trackable_type)
        if trackable_type[0] == "AdminUser"
          @activities = PublicActivity::Activity.where(owner_type: trackable_type)
        end
      end
      if action.present?
        @activities = @activities.where(key: action)
      end
      if recipient_type.present?
        @activities = @activities.where(recipient_type: recipient_type)
      end

      if time.present?
        @activities = @activities.where(created_at: time.beginning_of_day..time.end_of_day)
      end
      @activities = @activities.order(created_at: :desc)

      if params[:activities][:name].present? and not params[:activities][:name][0] == ""
        activity_array = []
        if trackable_type.present?
          if trackable_type[0] == "User"
            @activities.each do |activity|
              user = User.where(id: activity.trackable_id)[0]
              if user.present?
                if user.display_name.include? params[:activities][:name][0]
                  activity_array << activity
                end
              end
            end
          elsif trackable_type[0] == "Photographer"
            @activities.each do |activity|
              photographer = Photographer.where(id: activity.trackable_id)[0]
              if photographer.present?
                if (photographer.first_name + " " + photographer.last_name).include? params[:activities][:name][0]
                  activity_array << activity
                end
              end
            end
          elsif trackable_type[0] == "AdminUser"
            @activities.each do |activity|
              admin = AdminUser.where(id: activity.owner_id)[0]
              if admin.present?
                if admin.email.include? params[:activities][:name][0]
                  activity_array << activity
                end
              end
            end
          end
        else
          @activities.each do |activity|
            user = User.where(id: activity.trackable_id)[0]
            photographer = Photographer.where(id: activity.trackable_id)[0]

            if user.present?
              if user.display_name.include? params[:activities][:name][0]
                activity_array << activity
              end
            end
            if photographer.present?
              if (photographer.first_name.to_s + " " + photographer.last_name.to_s).include? params[:activities][:name][0]
                activity_array << activity
              end
            end
          end
        end
        @activities = activity_array
      end

      if params[:activities][:approve].present? and trackable_type.present?
        if params[:activities][:approve][0] == "on"
          activity_array = []
          @activities.each do |activity|
            photographer = Photographer.where(id: activity.trackable_id)[0]
            if photographer.present?
              if photographer.approved?
                activity_array << activity
              end
            end
          end
          @activities = activity_array
        end
      end

    end
  end
end
