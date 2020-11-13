class GtrendsController < ApplicationController
  
  before_action :set_gtrend,  only: [:destroy]
  before_action :all_gtrends
  
  def index
    @gtrend = Gtrend.new
    @gtrend.keywords.build
    
    
    
    @page_num = params[:page].nil? ? 1 : params[:page].to_i
    @replacement = @gtrends.offset(5 * @page_num).limit(1).first
  end
    
  def create
    @gtrend = Gtrend.new(gtrend_params)
    
    respond_to do |format|
      if @gtrend.save
        FetchGtrendDataJob.perform_later(@gtrend, @gtrend.kws)
        format.html { redirect_to gtrends_url }
        format.js
      else
        format.html { render :index }
        format.js
      end
    end
  end
    
  def destroy
    page_num = params[:page].nil? ? 1 : params[:page].to_i
    @replacement_gtrend = @gtrends.offset(5 * page_num).limit(1).first
    # delete more than one
    
    respond_to do |format|
      @gtrend.destroy
      format.html { redirect_to gtrends_url }
      format.js { flash.now[:notice] = 'Trend successfully deleted.' }
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
      params.require(:gtrend).permit(:name, :kws)
    end
  
end
