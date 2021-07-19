module Api
  module V1
    class GtrendsController < ApiController
      def index
        @gtrends = current_user
      end
    end
  end
end
