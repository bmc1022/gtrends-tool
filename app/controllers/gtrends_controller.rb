class GtrendsController < ApplicationController
  
  before_action :set_gtrend,  only: [:destroy]
  before_action :all_gtrends, only: [:index, :create]
  
  def index
    @gtrend = Gtrend.new
    @gtrend.keywords.build
  end
    
  def create
    @gtrend = Gtrend.new(gtrend_params)
    
    respond_to do |format|
      if @gtrend.save
        format.js
        format.html { redirect_to '/', notice: 'List successfully created' }
      else
        format.html { render :index }
      end
    end
  end
    
  def destroy
    @gtrend.destroy
    page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @js_replacement_trend = Gtrend.includes(:keywords).order("created_at DESC")
                                  .offset(page * 6).limit(1).first
    
    ## different page offset
    ## less than 6 records
    ## reload pagination partial on ajax success
    
    respond_to do |format|
      format.js
      format.html { redirect_to '/', alert: 'List successfully deleted' }
    end
  end
    
  private
  
    def set_gtrend
      @gtrend = Gtrend.find(params[:id])
    end
    
    def all_gtrends
      @pagy, @gtrends = pagy(Gtrend.includes(:keywords).order("created_at DESC"))
    end

    def gtrend_params
      params.require(:gtrend).permit(:name, keywords_attributes: [:id, :kw])
    end
  
end
