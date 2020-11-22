class ExpertiseWidgetsController < InheritedResources::Base
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  respond_to :js

  def show
    @expertise_widget_attachments = @expertise_widget.expertise_widget_attachments.all
  end


  def new
    @expertise_widget = ExpertiseWidget.new
    @expertise_widget_attachment = @expertise_widget.expertise_widget_attachments.build
  end

  def create
    @old_counter = params[:counter]
    @counter = @old_counter.to_i + 1
    @expertise = Expertise.find_by_id(params[:expertise][:id])
    widget = Widget.find_by_name(params[:widget][:name])
    if !widget.present?
      widget = Widget.create(name: params[:widget][:name])
    end
    @expertise_widget = ExpertiseWidget.find_by(expertise_id: @expertise.id, widget_id: widget.id)
    if !@expertise_widget.present?
      @expertise_widget = ExpertiseWidget.new(expertise_id: params[:expertise][:id] , widget_id: widget.id)
    end
    respond_to do |format|
      if @expertise_widget.save
        format.js
      end
    end
  end

  def destroy
    @expertise_widget.expertise_widget_attachments.each do |a|
      a.destroy
    end
    @expertise_widget.destroy
    respond_to do |format|
      format.html { redirect_to expertise_widgets_url }
      format.json { head :no_content }
    end
  end

  private

  def set_photo
    @expertise_widget = ExpertiseWidget.find(params[:id])
  end

  def expertise_widget_params
    params.require(:expertise_widget).permit(:widget_id, :expertise_id, expertise_widget_attachments_attributes:
      [:id, :photo, :expertise_widget_id])
  end

end
