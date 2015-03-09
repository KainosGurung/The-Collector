class SessionsController < ApplicationController

  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.authenticate(params[:provider_name], params[:password])

    if @provider
      session[:self_provider_id] = @provider.id
      session[:self_provider_name] = @provider.provider_name
      session[:self_admin] = @provider.admin
      if @provider.admin
        redirect_to admin_home_path
      else
        redirect_to provider_home_path
      end
    else
      flash.now.alert = 'Invalid name,password or your account has been deactivated.'
      render 'new'
    end
  end

  def destroy
    session[:self_provider_id] = nil
    session[:self_provider_name] = nil
    session[:self_admin] = nil
    redirect_to root_path, :notice => 'Logged out!'
  end
end
