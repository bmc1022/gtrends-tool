class GtrendsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'gtrends'
  end
end
