class GtrendsController < ApplicationController
  
  before_action :set_gtrend, only: [:show, :destroy]
  
  def index
    @gtrends = Gtrend.all
  end
  
  def show; end
    
  def new
    @gtrend = Gtrend.new
  end
    
  def create
    @gtrend = Gtrend.new(gtrend_params)
    if @gtrend.save
      flash[:success] = 'Item was successfully created'
      redirect_to @item
    else
      render 'new'
    end
  end
    
  def destroy
    @gtrend.destroy
    flash[:danger] = 'Item was successfully deleted'
    redirect_to root_path
  end
    
  private
  
    def set_gtrend
      @gtrend = Gtrend.find(params[:id])
    end

    def gtrend_params
      params.require(:gtrend).permit(:name, :keywords, :results)
    end
  
end
