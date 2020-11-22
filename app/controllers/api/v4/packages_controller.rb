class Api::V4::PackagesController < ApiController
  skip_before_action :authenticate_token
  respond_to :json
  before_action :find_project

  def index
    if @project.present? and @project.address.present? and @project.shoot_type.present?
      packages = Packages::PackageUnderCityAndShootType.call(discount: @project.address.city.impression_discount_package, shoot_type_id: @project.shoot_type_id).packages
      packages_json = ActiveModelSerializers::SerializableResource.new(
        packages, each_serializer: PackageSerializer,
      ).as_json
      render json: { packages: packages_json }.to_json, status: :accepted
    else
      render json: { errors: "Bad Request!" }, status: :bad_request
    end
  end
end
