class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
    
  protected

  def configure_permitted_parameters  
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  private

  def not_authorized
    if controller_name == "wikis" && action_name == "new"
      flash[:alert] = "You must sign up to create a new wiki."
      redirect_to new_user_registration_path
    else
      redirect_to root_url, alert: exception.message
    end
  end
end
