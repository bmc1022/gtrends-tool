class GtrendsController < ApplicationController

  include CableReady::Broadcaster

  before_action :set_gtrend,  only: [:destroy]
  before_action :all_gtrends

  def index
    @gtrend = Gtrend.new
    @gtrend.keywords.build
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
      end
    end
  end

  def destroy
    @gtrend.destroy
    redirect_to gtrends_url, status: :see_other
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
