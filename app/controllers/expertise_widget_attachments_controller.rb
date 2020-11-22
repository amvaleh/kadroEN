class ExpertiseWidgetAttachmentsController < InheritedResources::Base

  respond_to :json

  def create
    @photographer = Photographer.find(params[:photographer_id])
    @expertise_widget_attachment = ExpertiseWidgetAttachment.new(photo: params[:file])
    expertise_widget = ExpertiseWidget.find_by_id(params[:expertise_widget_id])
    if expertise_widget.expertise.photographer == @photographer
      @expertise_widget_attachment.expertise_widget = expertise_widget
      @expertise_widget_attachment.save
      valid = true
    end
    respond_to do |format|
      if valid
        format.html {
          render :json => [@expertise_widget_attachment.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {render json: {files: [@expertise_widget_attachment.to_jq_upload]}, status: :created, location: @expertise_widget_attachment.file_url(:medium)}
      else
        format.html {render action: "new"}
        format.json {render json: @expertise_widget_attachment.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @attachment = ExpertiseWidgetAttachment.find_by_id(params[:id])
    if @attachment.present?
      @attachment.destroy
      render json: @attachment, status: :ok
    end
  end

  private

  def expertise_widget_attachment_params
    params.require(:expertise_widget_attachment).permit(:expertise_widget_id, :photo)
  end

end
