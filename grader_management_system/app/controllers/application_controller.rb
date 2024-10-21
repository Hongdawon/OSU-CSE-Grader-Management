class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # Ensure the user is logged in before accessing any pages
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pagy::Backend

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:role, :email, :password, :password_confirmation)}

      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:role, :email, :password, :current_password, :password_confirmation)}
    end

  private

  # Method to check if the current user is an admin
  def check_if_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

  # Method to check if the current user is an instructor
  def check_if_instructor
    unless current_user.instructor?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end

  # Method to check if the current user is a student
  def check_if_student
    unless current_user.student?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
  
end
