class WelcomeController < ApplicationController
  before_filter :authenticate_admin_login, only: :admin_home
  before_filter :authenticate_provider_login, only: :provider_home

  def admin_home
  end

  def provider_home
  end

end