class ProvidersController < ApplicationController
  before_filter :authenticate_admin_login

  def new
    session[:provider_new_redirect_flag] = 1 #redirect flag used in providers#create
    @provider = Provider.new #Create new Provider object
  end

  def av_create_new_provider_and_assign_to_patient
    session[:provider_new_redirect_flag] = 2 #redirect flag used in providers#create
    session[:patient_provider_redirect_flag] = 2 #redirect flag used in patientproviders#create
    @provider = Provider.new
  end

  def index
    #Returns all active Provider records sorted by name
    @provider_array = Provider.all.where(active: true, admin: false).order(provider_name: :asc)
  end

  def index_inactive
    #Returns all active Provider records sorted by name
    @inactive_provider_array = Provider.all.where(active: false).order(provider_name: :asc)

  end

  def list
    #redirect flag used in patientproviders#create
    session[:patient_provider_redirect_flag] = 2

    #Save current url, used for: back/cancel buttons in providers/av_create_new_provider_and_assign_to_patient.html.erb
    session[:provider_list_url] = request.original_url

    #Returns all active Provider records sorted by name
    @provider_list_array = Provider.all.where(active: true, admin: false).order(provider_name: :asc)

    #Remove Providers that are already assigned to this Patient
    @provider_list_array -= Provider.where(id: Patientprovider.where(patient_id: params[:patient_id]).pluck(:provider_id))
  end

  def create
    @provider = Provider.new(provider_params)
    @provider.active = true

    case params["set_admin"].to_i
      when 1
        @provider.admin = 1
      when 0
        @provider.admin = 0
    end
    
    if @provider.save #Try to write Patient record to DB. Returns true if successful.
      #If a patient id was supplied when writing to DB, route to create a patientprovider record as well.
      if params[:patient_id] ##Comes from av_create_new_provider_and_assign_to_patient_path
        redirect_to av_create_new_patientprovider_path(@provider.id, params[:patient_id])
      else
        flash[:success] = 'New Provider Created'
        redirect_to av_show_all_providers_path('*') #else display provider index
      end
    else
      flash[:error] = 'Error Creating New Provider'

      #redirect based upon flag status
      if session[:provider_new_redirect_flag] == 1
        session[:provider_new_redirect_flag] = nil
        render 'new'

      elsif session[:provider_new_redirect_flag] ==2
        session[:provider_new_redirect_flag] = nil
        render 'av_create_new_provider_and_assign_to_patient'
      end
    end
  end

  def edit
    @provider = Provider.find(params[:provider_id])

    #save behavior name from the above query
    #original name is "lost" after an unsuccessful update
    session[:edit_provider_original_name] = @provider.provider_name

    #redirect flag used in providers#update and back/cancel links in providers/edit.html.erb
    if session[:self_provider_id] == @provider.id
      session[:edit_self_provider_redirect_flag] = 1
    else
      session[:edit_self_provider_redirect_flag] = 2
    end
  end

  def update
    @provider = Provider.find_by(id: params[:id]) #set variable to existing record
   
    case params["set_admin"].to_i #set admin status depending on state of radio buttons in the associated view
      when 1
        @provider.admin = 1
      when 0
        @provider.admin = 0
    end
    
    if @provider.update(provider_params) #try to update current DB entry with new information, returns true if successful
      flash[:success] = 'Provider Updated'
      #redirect based upon flag status
      if session[:edit_self_provider_redirect_flag] == 1
        session[:edit_self_provider_redirect_flag] = nil
        redirect_to admin_home_path

      elsif session[:edit_self_provider_redirect_flag] == 2
        session[:edit_self_provider_redirect_flag] = nil
        redirect_to av_show_all_providers_path
      end
    else
      flash[:error] = 'Error Updating Provider'
      render 'edit'
    end
  end

  def reactivate
    provider = Provider.find_by(id: params[:id]) #reset the patient to active
    provider.update(active: true)
    flash[:info] = 'Provider Reactivated'
    redirect_to av_show_all_inactive_providers_path
  end

  def deactivate
    provider = Provider.find_by(id: params[:id]) #set the patient to inactive
    provider.update(active: false)
    flash[:info] = 'Provider Deactivated'
    redirect_to av_show_all_providers_path
  end

  def delete
    @provider = Provider.delete(params[:id]) #Delete the Provider record that matches the passed in id
    redirect_to av_show_all_inactive_providers_path
  end

  def destroy
    @provider = Provider.destroy(params[:id]) #Delete the Provider record that matches the passed in id
    redirect_to av_show_all_inactive_providers_path   #and dependent records as well
  end

  def show
    #Save current url, used for: back button in providers/list.html.erb
    #                            redirect after a successful patientprovider incident record creation
    session[:provider_show_url] = request.original_url

    #Query Patientprovider table for records that match the patient id passed in.
    #Extract the provider ids from the returned records and
    #Query Provider table for active records that match the ids from the first query and are active
    @provider_show_array = Provider.where(id: Patientprovider.where(patient_id: params[:patient_id]).pluck(:provider_id), active: true, admin: false).order(provider_name: :asc)
  end

  private

  def provider_params
    params.require(:provider).permit(:provider_name, :password, :password_confirmation, :admin)
  end
end