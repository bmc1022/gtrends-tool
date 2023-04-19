# frozen_string_literal: true

class GtrendsChannel < ApplicationCable::Channel
  def subscribed
    stream_for(Gtrend.find(params[:gtrend_id]))
  end
end
