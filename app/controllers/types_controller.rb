class TypesController < ApplicationController
  layout "wordpress"

  before_action :find_shoot_type

  def show
    # to do
    # @photographers = Photographer.approved.joins(:expertises).where(:expertises=>{:approved=> true,:shoot_type_id=>@shoot_type.id})
    @photographers = Photographer.joins(:expertises)
      .where("expertises.approved = ? and expertises.shoot_type_id = ? and photographers.approved = ?", true, @shoot_type.id, true).sort_by { |ph| [-ph.last_sign_in_at] }
    data = SelectableImages::SelectTopImages.call(shoot_type: @shoot_type.id)
    @photos = data.photos
    # if data.photos.count > 0
    #   @photos = data.photos
    # # elsif @shoot_type.samples.present?
    #   # @samples = @shoot_type.samples
    # else
    #   @photos = []
    # #   @expertise_photos = Photo.joins(:expertise => :photographer).where( :expertises=>{shoot_type_id: @shoot_type.id} , :photographers=> {id: [@photographers.first(10)] })
    # end
    @good_feedbacks = FeedBack.where("feed_backs.publishable = ? and arate > ? and qrate > ? and description != ?", true, 8, 8, "").joins(project: :shoot_type).where("projects.package_id is not null and shoot_types.id = ?", @shoot_type.id).joins("left join users u on projects.user_id = u.id").last(100)
    @average_rating = FeedBack.where("feed_backs.publishable = ? and arate > ? and qrate > ? and description != ?", true, 8, 8, "").joins(project: :shoot_type).where("shoot_types.id = ?", @shoot_type.id).average(:qrate)
    if @average_rating.nil?
      @average_rating = 9
    end

    @cities = City.joins(:locations => :photographer).where(:photographers => { :approved => true, id: [@photographers] }).uniq
    @partners = @shoot_type.partners
    @cheapest_package = @shoot_type.packages.active.order("CAST(packages.price AS INT) ASC").first
    @expensivest_package = @shoot_type.packages.active.order("CAST(packages.price AS INT) ASC").last
    @all_feedbacks_count = @good_feedbacks.count
  end

  def index
    if params[:id].present?
      @shoot_types = ShootType.all.where("shoot_types.id in (#{params[:id].join(",")})")
    else
      @shoot_types = ShootType.all
    end
  end

  def find_shoot_type
    @shoot_type = ShootType.find_by(:w_url => params[:title])
  end
end
