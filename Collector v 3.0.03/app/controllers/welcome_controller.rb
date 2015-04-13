class WelcomeController < ApplicationController
  before_filter :authenticate_super_admin_login, only: :super_admin_home
  before_filter :authenticate_admin_login, only: :admin_home
  before_filter :authenticate_provider_login, only: :provider_home

  def super_admin_home
  end

  def admin_home
  end

  def provider_home
  end

  def index
  end
end