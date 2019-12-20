class GtrendsController < ApplicationController
  
  before_action :set_gtrend, only: [:destroy]
  
  def index
    @gtrend = Gtrend.new
    @pagy, @gtrends = pagy(Gtrend.all)
  end
    
  def create
    @gtrend = Gtrend.new(gtrend_params)
    if @gtrend.save
      flash[:success] = 'List was successfully created'
      redirect_to root_path
    else
      render 'new'
    end
  end
    
  def destroy
    @gtrend.destroy
    flash[:danger] = 'List was successfully deleted'
    redirect_to root_path
  end
    
  private
  
    def set_gtrend
      @gtrend = Gtrend.find(params[:id])
    end

    def gtrend_params
      params.require(:gtrend).permit(:name, keywords: [])
    end
  
end
