class WelcomeController < ApplicationController
  before_filter :authenticate_admin_login, only: :admin_home
  before_filter :authenticate_provider_login, only: :provider_home
  before_filter :redirect, only: :index

  def admin_home
  end

  def provider_home
  end

  private

  def redirect
    if session[:self_admin]
      redirect_to admin_home_path
    elsif session[:self_provider_id]
      redirect_to provider_home_path
    else
    end
  end
end