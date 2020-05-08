class GtrendsController < ApplicationController
  
  before_action :set_gtrend,  only: [:destroy]
  before_action :all_gtrends, only: [:index, :create]
  
  def index
    @gtrend = Gtrend.new
    @gtrend.keywords.build
  end
    
  def create
    @gtrend = Gtrend.new(gtrend_params)
    
    if @gtrend.save
      FetchGtrendDataJob.perform_later(@gtrend, @gtrend.kws)
      redirect_to gtrends_url
    else
      render :index
    end
  end
    
  def destroy
    @gtrend.destroy
    redirect_to gtrends_url
  end
    
  private
  
    def set_gtrend
      @gtrend = Gtrend.find(params[:id])
    end
    
    def all_gtrends
      @pagy, @gtrends = pagy(Gtrend.includes(:keywords).order("created_at DESC"))
    end

    def gtrend_params
      params.require(:gtrend).permit(:name, :kws)
    end
  
end
