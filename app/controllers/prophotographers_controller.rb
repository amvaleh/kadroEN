class ProphotographersController < ApplicationController
  layout "kadro"
  before_action :find_photographer, :only => [:show, :call]
  before_action :authenticate_user!, only: :call
  before_action :base_url

  def call
    if @photographer.callable
      @call = Call.find_or_create_by(:photographer => @photographer, :user => current_user)
    end
  end

  def city_expertise_list
    @shoot_type_ids = Expertise.joins(:photographer).where(:photographers => { approved: true }, :expertises => { approved: true }).group(:shoot_type_id).joins("INNER JOIN locations ON locations.id = photographers.location_id INNER JOIN cities ON cities.id = locations.city_id").where(:cities => { :name => params[:city_name] }).count

    @cities = ActiveCity.all
    @city_photographers = Photographer.approved.joins(:location => :city).where(:cities => { :name => params[:city_name] })
    @photographers = @city_photographers.joins(:expertises => :shoot_type).where(:shoot_types => { :title => params[:shoot_type] }, :expertises => { :approved => true }).uniq

    @expertise = Expertise.find_by(shoot_type_id: ShootType.find_by(title: params[:shoot_type]).id)
    @city = City.find_by(name: params[:city_name])

    @has_good_feedback = nil
    @good_feedbacks = GoodFeedbacks::SearchGoodFeedbacksWithCityNameAndExpertiseAndLimit.call(city_name: params[:city_name], shoot_type_name: params[:shoot_type], limit: 20).good_feedbacks
    delivered_photos_count = 90
    total_feedbacks = 9
    total_hours = 3

    feedback_count = 1
    galleries_count = 1
    projects_count = 1

    @average_feedback = 9
    @average_delivers = 90
    @average_hours = 3
    @average_shooted_hours = 40

    @photographers.each do |ph|
      ph.projects.checked_out.each do |p|
        if p.package.present?
          projects_count = projects_count + 1
          total_hours = total_hours + p.package.order
        end
        if p.gallery.present?
          galleries_count = galleries_count + 1
          delivered_photos_count = delivered_photos_count + p.gallery.total_frames.to_i
        end
      end
    end
    @average_feedback = (total_feedbacks / feedback_count)
    @average_delivers = (delivered_photos_count / galleries_count)
    @average_hours = (total_hours / projects_count)
    @average_shooted_hours = (delivered_photos_count / total_hours)
  end

  def expertise_list
    if params[:shoot_type].present?
      @shoot_types_ids = Expertise.joins(:photographer).where(:photographers => { approved: true }, :expertises => { approved: true }).group(:shoot_type_id).count
      @cities = ActiveCity.all
      @photographers = Photographer.approved.joins(:expertises => :shoot_type).where(:shoot_types => { :title => params[:shoot_type] }, :expertises => { :approved => true }).uniq
      @expertise = Expertise.find_by(shoot_type_id: ShootType.find_by(title: params[:shoot_type]))
      @has_good_feedback = nil
      @good_feedbacks = GoodFeedbacks::SearchGoodFeedbacksWithExpertiseAndLimit.call(shoot_type_name: params[:shoot_type], limit: 20).good_feedbacks
    end
    set_cookie
  end

  def city_list
    @shoot_type_ids = Expertise.joins(:photographer).where(:photographers => { approved: true }, :expertises => { approved: true }).group(:shoot_type_id).joins("INNER JOIN locations ON locations.id = photographers.location_id INNER JOIN cities ON cities.id = locations.city_id").where(:cities => { :name => params[:city_name] }).count
    @cities = ActiveCity.all
    @photographers = Photographer.approved.joins(:location => :city).where(:cities => { :name => params[:city_name] })
    @city = City.find_by(name: params[:city_name])
    @has_good_feedback = nil
    delivered_photos_count = 90
    total_feedbacks = 9
    total_hours = 3
    feedback_count = 1
    galleries_count = 1
    projects_count = 1

    @average_feedback = 9
    @average_delivers = 90
    @average_hours = 3
    @average_shooted_hours = 40
    @good_feedbacks = GoodFeedbacks::SearchGoodFeedbacksWithCityNameAndLimit.call(city_name: params[:city_name], limit: 20).good_feedbacks
    @photographers.each do |ph|
      ph.projects.checked_out.each do |p|
        if p.package.present?
          projects_count = projects_count + 1
          total_hours = total_hours + p.package.order
        end
        if p.gallery.present?
          galleries_count = galleries_count + 1
          delivered_photos_count = delivered_photos_count + p.gallery.total_frames.to_i
        end
      end
    end
    @average_feedback = (total_feedbacks / feedback_count)
    @average_delivers = (delivered_photos_count / galleries_count)
    @average_hours = (total_hours / projects_count)
    @average_shooted_hours = (delivered_photos_count / total_hours)
    set_cookie
  end

  def index2
    @shoot_type_ids = Expertise.joins(:photographer).where(:photographers => { approved: true }, :expertises => { approved: true }).group(:shoot_type_id).count
    @cities = ActiveCity.all
    @photographers = Photographer.approved
    # @expertise = Expertise.find_by(shoot_type_id: ShootType.find_by(title:params[:shoot_type]).id)

    @has_good_feedback = nil
    @good_feedbacks = GoodFeedbacks::SearchGoodFeedbacksWithLimit.call(limit: 20).good_feedbacks
    set_cookie
  end

  def index
    if params[:city_name].present? && params[:shoot_type].present?
      @shoot_type_all = ShootType.joins(:expertises => :photographer).where(:photographers => { :approved => true }).uniq
      @shoot_types = @shoot_type_all.joins("INNER JOIN locations ON locations.id = photographers.location_id INNER JOIN cities ON cities.id = locations.city_id").where(:cities => { :name => params[:city_name] }).uniq
      @cities = ActiveCity.all
      @city_photographers = Photographer.approved.joins(:location => :city).where(:cities => { :name => params[:city_name] })
      @photographers = @city_photographers.joins(:expertises => :shoot_type).where(:shoot_types => { :title => params[:shoot_type] }).uniq
    elsif params[:city_name].present?
      @shoot_type_all = ShootType.joins(:expertises => :photographer).where(:photographers => { :approved => true }).uniq
      @shoot_types = @shoot_type_all.joins("INNER JOIN locations ON locations.id = photographers.location_id INNER JOIN cities ON cities.id = locations.city_id").where(:cities => { :name => params[:city_name] }).uniq
      @cities = City.joins(:locations => :photographer).where(:photographers => { :approved => true }).uniq
      @photographers = Photographer.approved.joins(:location => :city).where(:cities => { :name => params[:city_name] })
    elsif params[:shoot_type].present?
      @shoot_types = ShootType.joins(:expertises => :photographer).where(:photographers => { :approved => true }).uniq
      @cities = City.joins(:locations => :photographer).where(:photographers => { :approved => true }).uniq
      @photographers = Photographer.approved.joins(:expertises => :shoot_type).where(:shoot_types => { :title => params[:shoot_type] }).uniq
    else
      @shoot_types = ShootType.joins(:expertises => :photographer).where(:photographers => { :approved => true }).uniq
      @cities = City.joins(:locations => :photographer).where(:photographers => { :approved => true }).uniq
      @photographers = Photographer.approved #
    end

    @photographers = @photographers

    # @photographers.each do |photographer|
    #   Photographers::Analyze::MakeShootSuggestion.call(photographer_id: photographer.id, cookies: cookies)
    # end
    set_cookie
  end

  def query
    if params[:city_name].present? && params[:shoot_type].present?
      @shoot_type_all = ShootType.joins(:expertises => :photographer).where(:photographers => { :approved => true })
      @shoot_types = @shoot_type_all.joins("INNER JOIN locations ON locations.id = photographers.location_id INNER JOIN cities ON cities.id = locations.city_id").where(:cities => { :name => params[:city_name] })
      @cities = City.joins(:locations => :photographer).where(:photographers => { :approved => true }).uniq
      @city_photographers = Photographer.approved.joins(:location => :city).where(:cities => { :name => params[:city_name] })
      @photographers = @city_photographers.joins(:expertises => :shoot_type).where(:shoot_types => { :title => params[:shoot_type] }, :expertises => { :approved => true }).uniq
      if params[:gender] == "male"
        @photographers = @photographers.male
      elsif params[:gender] == "female"
        @photographers = @photographers.female
      end
    elsif params[:city_name].present?
      @shoot_type_all = ShootType.joins(:expertises => :photographer).where(:photographers => { :approved => true })
      @shoot_types = @shoot_type_all.joins("INNER JOIN locations ON locations.id = photographers.location_id INNER JOIN cities ON cities.id = locations.city_id").where(:cities => { :name => params[:city_name] })
      @cities = City.joins(:locations => :photographer).where(:photographers => { :approved => true }).uniq
      @photographers = Photographer.approved.joins(:location => :city).where(:cities => { :name => params[:city_name] })
      if params[:gender] == "male"
        @photographers = @photographers.male
      elsif params[:gender] == "female"
        @photographers = @photographers.female
      end
    elsif params[:shoot_type].present?
      @shoot_types = ShootType.joins(:expertises => :photographer).where(:photographers => { :approved => true })
      @cities = City.joins(:locations => :photographer).where(:photographers => { :approved => true }).uniq
      @photographers = Photographer.approved.joins(:expertises => :shoot_type).where(:shoot_types => { :title => params[:shoot_type] }, :expertises => { :approved => true }).uniq
      if params[:gender] == "male"
        @photographers = @photographers.male
      elsif params[:gender] == "female"
        @photographers = @photographers.female
      end
    else
      @shoot_types = ShootType.joins(:expertises => :photographer).where(:photographers => { :approved => true })
      @cities = City.joins(:locations => :photographer).where(:photographers => { :approved => true }).uniq
      @photographers = Photographer.approved #
      if params[:gender] == "male"
        @photographers = @photographers.male
      elsif params[:gender] == "female"
        @photographers = @photographers.female
      end
    end
    if params[:has_studio] == "true"
      @photographers = @photographers.where(:has_studio => params[:has_studio])
    end
  end

  def set_cookie
    cookies[:visit] = {
      value: Time.now,
      expires: 5.minute.from_now,
    }
  end

  def show
    @shoot_location = ShootLocation.find_by(photographer_id: @photographer.id, is_studio: true, approved: true)
    Photographers::Analyze::MakeShootSuggestion.call(photographer_id: @photographer.id, cookies: cookies)
    @projects_feedbacked = Project.joins(:feed_back).where("photographer_id = ?", @photographer.id)
    @available_hours = FreeTimes::CalculateAvailableWeekHours.call(photographer_id: @photographer.id).available_hours
    @has_good_feedback = nil
    @good_feedbacks = []
    @projects_feedbacked.order("created_at desc").each do |p|
      if p.feed_back.publishable
        @has_good_feedback = true
        if p.feed_back.description.present?
          @good_feedbacks << p
        end
      end
    end
    @header_photo = @photographer.expertises.sample.photos.sample
    set_cookie
  end

  private

  def find_photographer
    @photographer = Photographer.find_by(uid: params[:id])
    if !@photographer.present? and Rails.env.production?
      redirect_to "/"
    end
  end

  def base_url
    if Rails.env.production?
      @base_url = "https://pro.kadro.me/"
    else
      @base_url = "http://pro.localhost:3000/"
    end
  end
end
