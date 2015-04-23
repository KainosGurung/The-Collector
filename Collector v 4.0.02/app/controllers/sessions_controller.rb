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
      if @provider.admin == 0
        redirect_to pv_patient_record_arrays_path
      elsif @provider.admin == 1
        redirect_to admin_home_path
      elsif @provider.admin == 2
        session[:self_super_admin] = 1
        redirect_to super_admin_home_path
      end
    else
      flash[:error] = 'Log in failed'
      render 'new'
    end
  end

  def destroy
    reset_session #deletes all session variables
    flash[:info] = 'Logged out!'
    redirect_to root_path
  end
end
