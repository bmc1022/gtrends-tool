# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Middleware::SidekiqAuth) do
  let(:app)        { MockRackApp.new }
  let(:middleware) { described_class.new(app) }
  let(:env)        { { "PATH_INFO" => path, "warden" => instance_double(Warden::Proxy, user:) } }

  before { allow(app).to receive(:call).and_call_original }

  describe "#call" do
    context "when accessing the Sidekiq dashboard" do
      let(:path) { "/sidekiq" }

      context "when the user is authorized" do
        let(:user) { create(:user, :admin) }

        it "grants access to the dashboard" do
          middleware.call(env)
          expect(app).to have_received(:call).with(env)
          expect(app.env).not_to be_nil
        end
      end

      context "when the user is unauthorized" do
        let(:user) { nil }

        it "redirects to the login path" do
          result = middleware.call(env)
          expect(result).to eq(
            [302, { "Location" => "/login", "Content-Type" => "text/html" }, ["Redirecting..."]]
          )
        end
      end
    end

    context "when accessing other paths" do
      let(:user) { create(:user, :admin) }
      let(:path) { "/other_path" }

      it "proceeds with the request" do
        middleware.call(env)
        expect(app).to have_received(:call).with(env)
        expect(app.env).not_to be_nil
      end
    end
  end
end
