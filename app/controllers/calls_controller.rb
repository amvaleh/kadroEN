class CallsController < InheritedResources::Base


  before_action :find_call

  def update
    @call.update(call_params)
    redirect_to pro_path(@call.photographer.uid),notice:"با تشکر از بازخورد شما."
  end


  private

  def call_params
    params.require(:call).permit(:photographer_id, :user_id, :rate)
  end


    def find_call
      @call = Call.find(params[:id])
    end

end
