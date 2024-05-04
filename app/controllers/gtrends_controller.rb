# frozen_string_literal: true

class GtrendsController < ApplicationController
  before_action :set_gtrend, only: [:destroy]
  before_action :load_gtrends

  def index
    authorize(Gtrend)
    @gtrend = Gtrend.new
    @gtrend.keywords.build
  end

  def create
    @gtrend = build_gtrend_with_owner(gtrend_params)
    authorize(@gtrend)

    respond_to do |format|
      if @gtrend.save
        FetchGtrendDataJob.perform_later(@gtrend.id, @gtrend.kws)
        format.html { redirect_to(gtrends_url, notice: "Trend was successfully created.") }
      else
        format.json { render(json: @gtrend.errors.messages, status: :unprocessable_entity) }
      end
    end
  end

  def destroy
    authorize(@gtrend)
    @gtrend.destroy!
    redirect_to(gtrends_url, status: :see_other, notice: "Trend was successfully removed.")
  end

  private

  def set_gtrend
    @gtrend = Gtrend.find(params[:id])
  end

  def load_gtrends
    filtered_gtrends = policy_scope(Gtrend).includes(:keywords).order(created_at: :desc)
    @pagy, @gtrends = pagy(filtered_gtrends)
  end

  def build_gtrend_with_owner(gtrend_params)
    Gtrend.new(gtrend_params).tap do |gtrend|
      if user_signed_in?
        gtrend.user = current_user
      else
        gtrend.guest_id = guest_identifier
      end
    end
  end

  def gtrend_params
    params.require(:gtrend).permit(:name, :kws)
  end
end
