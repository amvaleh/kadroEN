class Api::V3::ShootTypesController < ApiController
  respond_to :json
  before_action :find_project

  def submit_shoot_type
    unless shoot_type_params[:id]
      render json: { errors: ["لطفا پارامتر رشته انتخابی را درست وارد نمایید"] }.to_json, status: :bad_request
      return
    end

    @active_packages = Package.active.where(shoot_type_id: shoot_type_params[:id])
    if @active_packages.any?
      Project.where(id: @project.id).update_all(shoot_type_id: shoot_type_params[:id])

      @project.create_activity :submitted_shoot_type, owner: @project.user, recipient: ShootType.where(id: shoot_type_params[:id])[0]
      shoot_location = ShootLocation.find_by(slug: params[:shoot_location])
      if shoot_location.present?
        address_shoot_location = shoot_location.address
        @address = Project.find_by(id: @project.id).address
        @project.set_reserve_step("location")
        @project.in_studio = false
        if @address.present?
          Address.where(id: @address.id).first.update_attributes(longtitude: shoot_location.address.longtitude, lattitude: shoot_location.address.lattitude, input: shoot_location.address.input, detail: shoot_location.address.detail)
          message = " آدرس با موفقیت ذخیره شد"
        else
          @address = Address.create(longtitude: shoot_location.address.longtitude, lattitude: shoot_location.address.lattitude, input: shoot_location.address.input, detail: shoot_location.address.detail)
          Project.where(id: @project.id).first.update_attributes(address_id: @address.id)
          message = "آدرس برای پروژه ساخته شد"
        end
        if (shoot_location.photographer.present?) && (shoot_location.shoot_location_type.title == "آتلیه") && (shoot_location.is_studio == true)
          @project.photographer = shoot_location.photographer
          @project.in_studio = true
          @project.direct_book = true
          photographer = shoot_location.photographer
          avatar_url = photographer.avatar.mini.url
          available_hours = FreeTimes::CalculateAvailableWeekHours.call(photographer_id: photographer.id).available_hours
          active_days = photographer.free_times
          days = []
          active_days.each do |ad|
            days << ad.day
          end
        end
        @project.save
      end
      if photographer.present?
        abbrv_name = photographer.abbrv_name
      end
      if params[:shoot_location].present?
        shoot_location_address = ShootLocation.find_by(slug: params[:shoot_location]).address
        if shoot_location_address.present?
          @packages = Packages::PackageUnderCityAndShootType.call(discount: shoot_location.address.city.impression_discount_package, shoot_type_id: shoot_type_params[:id]).packages
        end
      end
      if params[:photographer].present?
        photographer = Photographer.find_by_uid(params[:photographer])
        direct_city_name = photographer.location.city.name
        render json: { packages: [@packages],
                       recommendation: ShootType.find(shoot_type_params[:id]).recommended_hours,
                       direct_city_name: direct_city_name, direct_photographer_name: photographer.display_name, shoot_location: shoot_location, days: [days], avatar_url: avatar_url, available_hours: available_hours, photographer_name: abbrv_name, address_shoot_location: address_shoot_location, photographer: photographer }.to_json, status: :accepted
      else
        render json: { packages: [@packages],
                       recommendation: ShootType.find(shoot_type_params[:id]).recommended_hours, shoot_location: shoot_location, photographer: photographer, days: [days], avatar_url: avatar_url, available_hours: available_hours, photographer_name: abbrv_name, address_shoot_location: address_shoot_location }.to_json, status: :accepted
      end
    else
      render json: { errors: ["رشته خود را درست انتخاب کنید"] }, status: :bad_request
    end
  end

  def accept_shoot_type
    unless shoot_type_params[:id]
      render json: { errors: ["لطفا پارامتر رشته انتخابی را درست وارد نمایید"] }.to_json, status: :bad_request
      return
    end

    @active_packages = Package.active.where(shoot_type_id: shoot_type_params[:id])
    if @active_packages.any?
      Project.where(id: @project.id).update_all(shoot_type_id: shoot_type_params[:id])

      @project.create_activity :submitted_shoot_type, owner: @project.user, recipient: ShootType.where(id: shoot_type_params[:id])[0]
      shoot_location = ShootLocation.find_by(slug: params[:shoot_location])
      if shoot_location.present?
        address_shoot_location = shoot_location.address
        @address = Project.find_by(id: @project.id).address
        @project.set_reserve_step("location")
        @project.in_studio = false
        if @address.present?
          Address.where(id: @address.id).first.update_attributes(longtitude: shoot_location.address.longtitude, lattitude: shoot_location.address.lattitude, input: shoot_location.address.input, detail: shoot_location.address.detail)
          message = " آدرس با موفقیت ذخیره شد"
        else
          @address = Address.create(longtitude: shoot_location.address.longtitude, lattitude: shoot_location.address.lattitude, input: shoot_location.address.input, detail: shoot_location.address.detail)
          Project.where(id: @project.id).first.update_attributes(address_id: @address.id)
          message = "آدرس برای پروژه ساخته شد"
        end
        if (shoot_location.photographer.present?) && (shoot_location.shoot_location_type.title == "آتلیه") && (shoot_location.is_studio == true)
          @project.photographer = shoot_location.photographer
          @project.in_studio = true
          @project.direct_book = true
          photographer = shoot_location.photographer
          avatar_url = photographer.avatar.mini.url
          available_hours = FreeTimes::CalculateAvailableWeekHours.call(photographer_id: photographer.id).available_hours
          active_days = photographer.free_times
          days = []
          active_days.each do |ad|
            days << ad.day
          end
        end
        @project.save
      end
      if photographer.present?
        abbrv_name = photographer.abbrv_name
      end
      if params[:shoot_location].present?
        shoot_location_address = ShootLocation.find_by(slug: params[:shoot_location]).address
        if shoot_location_address.present?
          @packages = Packages::PackageUnderCityAndShootType.call(discount: shoot_location.address.city.impression_discount_package, shoot_type_id: shoot_type_params[:id]).packages
          packages_json = ActiveModelSerializers::SerializableResource.new(
            @packages, each_serializer: PackageSerializer,
          ).as_json
        end
      end
      if params[:photographer].present?
        photographer = Photographer.find_by_uid(params[:photographer])
        direct_city_name = photographer.location.city.name
        render json: { packages: [packages_json],
                       recommendation: ShootType.find(shoot_type_params[:id]).recommended_hours,
                       direct_city_name: direct_city_name, direct_photographer_name: photographer.display_name, shoot_location: shoot_location, days: [days], avatar_url: avatar_url, available_hours: available_hours, photographer_name: abbrv_name, address_shoot_location: address_shoot_location, photographer: photographer }.to_json, status: :accepted
      else
        render json: { packages: [packages_json],
                       recommendation: ShootType.find(shoot_type_params[:id]).recommended_hours, shoot_location: shoot_location, photographer: photographer, days: [days], avatar_url: avatar_url, available_hours: available_hours, photographer_name: abbrv_name, address_shoot_location: address_shoot_location }.to_json, status: :accepted
      end
    else
      render json: { errors: ["رشته خود را درست انتخاب کنید"] }, status: :bad_request
    end
  end

  private

  def shoot_type_params
    params.require(:shoot_type).permit(:id)
  end
end
