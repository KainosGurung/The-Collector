class SessionsController < ApplicationController

  def new
    # if session[:self_provider_id].present?
    #   redirect_to root_path
    # end
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
        redirect_to pv_patient_record_arrays_path
      end
    else
      flash[:error] = 'Log in failed'
      render 'new'
    end
  end

  def destroy
    session[:self_provider_id] = nil
    session[:self_provider_name] = nil
    session[:self_admin] = nil
    flash[:info] = 'Logged out!'
    redirect_to root_path
  end
end
