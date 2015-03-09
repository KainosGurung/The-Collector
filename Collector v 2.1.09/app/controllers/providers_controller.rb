class ProvidersController < ApplicationController
  before_filter :authenticate_admin_login

  def new
    @provider = Provider.new #Create new Provider object
  end

  def av_create_new_provider_and_assign_to_patient
    session[:patient_provider_flag] = 2
    @provider = Provider.new
  end

  def index
    #Returns all active Provider records sorted by name
    @provider_array = Provider.all.where(active: true, admin: false).order(provider_name: :asc)
  end

  def index_inactive
    #Returns all active Provider records sorted by name
    @provider_array = Provider.all.where(active: false).order(provider_name: :asc)

  end

  def list
    session[:patient_provider_flag] = 2
    session[:provider_list_url] = request.original_url    #Save current url

    #Returns all active Provider records sorted by name
    @provider_array = Provider.all.where(active: true, admin: false).order(provider_name: :asc)
    #Remove Providers that are already assigned to this Patient
    @provider_array -= Provider.where(id: Patientprovider.where(patient_id: params[:patient_id]).pluck(:provider_id))
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
        redirect_to av_show_all_providers_path('*') #else display provider index
      end
    else
      render 'error'
    end
  end

  def edit
    @provider = Provider.find(params[:provider_id])

    #Save original name of the provider that was passed in before we try to update it
    session[:edit_provider_original_name] = @provider.provider_name

    #Set flag if you try to edit your own account
    if session[:self_provider_id] == @provider.id
      session[:edit_self_flag] = 1 
    else
      session[:edit_self_flag] = 0
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
    
    if @provider.update(provider_params) #try to update current DB entry with new information, if unsuccessful then render error
      if session[:edit_self_flag] == 1
        redirect_to admin_home_path
      else
        redirect_to av_show_all_providers_path
      end
    else
      render 'edit_error'
    end
  end

  def reactivate
    provider = Provider.find_by(id: params[:id]) #reset the patient to active
    provider.update(active: true)
    redirect_to av_show_all_inactive_providers_path
  end

  def deactivate
    provider = Provider.find_by(id: params[:id]) #set the patient to inactive
    provider.update(active: false)
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
    session[:provider_show_url] = request.original_url    #Save current url

    #Query Patientprovider table for records that match the patient id passed in.
    #Extract the provider ids from the returned records and
    #Query Provider table for active records that match the ids from the first query and are active
    @provider_name_array = Provider.where(id: Patientprovider.where(patient_id: params[:patient_id]).pluck(:provider_id), active: true, admin: false).order(provider_name: :asc)
  end

  private

  def provider_params
    params.require(:provider).permit(:provider_name, :password, :password_confirmation, :admin)
  end
end