class Api::V1::ExpertisesController < ApiController
  skip_before_action :authenticate_token
  include Swagger::Docs::Methods
  respond_to :json


  def index
    links = []
    if params[:shoot_type].present?
      st = params[:shoot_type]
      shoot_type = ShootType.find(st)
      exps = Expertise.joins(:photographer).where(:approved=>true , :shoot_type=> shoot_type,:photographers=> {:approved=>true})
    else
      exps = Expertise.joins(:photographer).where(:approved=>true ,:photographers=> {:approved=>true})
    end

    exps.each do |exp|
      exp.photos.each do |p|
        links << p.file_url(:large)
      end
    end

    render json: {links: links}
  end

  def destroy
    result = Expertises::ExpertiseDestroy.call(id: params[:id], photographer: @photographer)
    if result.success?
      render json: Rw::SuccessResponse.call().result
    else
      render json: {errors: result.errors}, status: :bad_request
    end
  rescue Exception => e
    render json: {errors: e.message}, status: :bad_request
  end
end
