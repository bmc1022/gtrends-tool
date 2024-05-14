# frozen_string_literal: true

module Middleware
  class SidekiqAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.path.start_with?("/sidekiq") && !authorized?(request)
        [302, { "Location" => "/login", "Content-Type" => "text/html" }, ["Redirecting..."]]
      else
        @app.call(env)
      end
    end

    private

    def authorized?(request)
      user = request.env["warden"].user
      user&.has_role?(:admin) || false
    end
  end
end
