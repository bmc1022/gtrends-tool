# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action  :verify_authorized
  after_action  :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION["warden"] ||= "warden"
    warden_proxy = warden_proxy_for_user(user)
    renderer.new("warden" => warden_proxy).render(*args)
  end

  def self.warden_proxy_for_user(user)
    Warden::Proxy.new({}, Warden::Manager.new({})).tap do |proxy|
      proxy.set_user(user, scope: :user)
    end
  end

  protected

  def pundit_user
    user_signed_in? ? current_user : Guest.new(guest_identifier)
  end

  def guest_identifier
    cookies[:guest_identifier] ||= { value: SecureRandom.uuid, expires: 1.month }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end
end
