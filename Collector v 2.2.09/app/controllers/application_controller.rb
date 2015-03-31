class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #force_ssl #https

  private

  def authenticate_admin_login
    unless session[:self_admin] #If this session hash doesn't equal 1, do:
      flash[:danger] = 'Please login as an admin to view this page.'
      redirect_to log_in_path
    end
  end

  def authenticate_provider_login
    unless session[:self_provider_id]
      flash[:danger] = 'Please login to view this page.'
      redirect_to log_in_path
    end
  end

end
