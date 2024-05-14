# frozen_string_literal: true

class MockRackApp
  attr_reader :env, :request_body

  def call(env)
    @env = env
    @request_body = env["rack.input"]&.read
    [200, { "Content-Type" => "text/html" }, ["Success"]]
  end

  def [](key)
    @env[key]
  end
end
