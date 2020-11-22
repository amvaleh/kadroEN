class Api::V3::AddressesController < ApiController
  respond_to :json
  before_action :find_project

  def submit_address
    unless addresses_params[:detail]
      render json: { errors: ["مقدار صحیح را وارد نمایید"] }.to_json, status: :bad_request
      return
    end
    @address = Project.find_by(id: @project.id).address
    @project.set_reserve_step("location")
    @project.in_studio = false
    @project.search_for_studio = false
    if addresses_params[:show_studios].present? && addresses_params[:show_studios] == "true"
      @project.search_for_studio = true
      @project.in_studio = true
    end
    @project.save
    if @address.present?
      # Address.where(id: @address.id).first.update_attributes(longtitude: addresses_params[:longtitude], lattitude: addresses_params[:lattitude], input: addresses_params[:input], detail: addresses_params[:detail])
      @address = Addresses::UpdateAddress.call(id: @address.id, lattitude: addresses_params[:lattitude], longtitude: addresses_params[:longtitude], input: addresses_params[:input], detail: addresses_params[:detail]).address
      message = " آدرس با موفقیت ذخیره شد"
    else
      @address = Address.create(longtitude: addresses_params[:longtitude], lattitude: addresses_params[:lattitude], input: addresses_params[:input], detail: addresses_params[:detail])
      # Project.where(id: @project.id).first.update_attributes(address_id: @address.id)
      @project.address_id = @address.id
      @project.save
      message = "آدرس برای پروژه ساخته شد"
    end
    @packages = Packages::PackageUnderCityAndShootType.call(discount: @address.city.impression_discount_package, shoot_type_id: @project.shoot_type_id).packages
    # check for direct book photographer available days
    if params[:photographer].present?
      photographer = Photographer.find_by(uid: params[:photographer])
      avatar_url = photographer.avatar.mini.url
      available_hours = FreeTimes::CalculateAvailableWeekHours.call(photographer_id: photographer.id).available_hours
      active_days = photographer.free_times
      days = []
      active_days.each do |ad|
        days << ad.day
      end
      @project.direct_book = true
      # check for in-studio if direct book

      if addresses_params[:in_studio] == "true"
        @shoot_location = ShootLocation.find_by(photographer_id: photographer.id, is_studio: true)
        if @shoot_location.present?
          @address.detail = @shoot_location.address.detail
          @address.save
        else
          @address.detail = photographer.location.living_address
          @address.save
        end
        @project.in_studio = true
      end
      #
      @project.save
      render json: { messages: [message], days: [days], avatar_url: avatar_url, available_hours: available_hours, photographer_name: photographer.abbrv_name, packages: @packages }, result: "True", status: :accepted
    else
      @project.save
      render json: { messages: [message], packages: @packages }, result: "True", status: :accepted
    end
  end

  def accept_address
    unless addresses_params[:detail]
      render json: { errors: ["مقدار صحیح را وارد نمایید"] }.to_json, status: :bad_request
      return
    end
    @address = Project.find_by(id: @project.id).address
    @project.set_reserve_step("location")
    @project.in_studio = false
    @project.search_for_studio = false
    if addresses_params[:show_studios].present? && addresses_params[:show_studios] == "true"
      @project.search_for_studio = true
      @project.in_studio = true
    end
    @project.save
    if @address.present?
      # Address.where(id: @address.id).first.update_attributes(longtitude: addresses_params[:longtitude], lattitude: addresses_params[:lattitude], input: addresses_params[:input], detail: addresses_params[:detail])
      @address = Addresses::UpdateAddress.call(id: @address.id, lattitude: addresses_params[:lattitude], longtitude: addresses_params[:longtitude], input: addresses_params[:input], detail: addresses_params[:detail]).address
      message = " آدرس با موفقیت ذخیره شد"
    else
      @address = Address.create(longtitude: addresses_params[:longtitude], lattitude: addresses_params[:lattitude], input: addresses_params[:input], detail: addresses_params[:detail])
      # Project.where(id: @project.id).first.update_attributes(address_id: @address.id)
      @project.address_id = @address.id
      @project.save
      message = "آدرس برای پروژه ساخته شد"
    end
    @packages = Packages::PackageUnderCityAndShootType.call(discount: @address.city.impression_discount_package, shoot_type_id: @project.shoot_type_id).packages
    packages_json = ActiveModelSerializers::SerializableResource.new(
      @packages, each_serializer: PackageSerializer,
    ).as_json
    # check for direct book photographer available days
    if params[:photographer].present?
      photographer = Photographer.find_by(uid: params[:photographer])
      avatar_url = photographer.avatar.mini.url
      available_hours = FreeTimes::CalculateAvailableWeekHours.call(photographer_id: photographer.id).available_hours
      active_days = photographer.free_times
      days = []
      active_days.each do |ad|
        days << ad.day
      end
      @project.direct_book = true
      # check for in-studio if direct book

      if addresses_params[:in_studio] == "true"
        @shoot_location = ShootLocation.find_by(photographer_id: photographer.id, is_studio: true)
        if @shoot_location.present?
          @address.detail = @shoot_location.address.detail
          @address.save
        else
          @address.detail = photographer.location.living_address
          @address.save
        end
        @project.in_studio = true
      end
      #
      @project.save
      render json: { messages: [message], days: [days], avatar_url: avatar_url, available_hours: available_hours, photographer_name: photographer.abbrv_name, packages: packages_json }, result: "True", status: :accepted
    else
      @project.save
      render json: { messages: [message], packages: packages_json }, result: "True", status: :accepted
    end
  end

  private

  def addresses_params
    params.require(:address).permit(:lattitude, :longtitude, :input, :detail, :in_studio, :show_studios)
  end
end
