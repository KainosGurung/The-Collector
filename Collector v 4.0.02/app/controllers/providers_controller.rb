class ProvidersController < ApplicationController
  before_filter :authenticate_admin_login, except: [:new_admin, :admin_index, :admin_index_inactive, :edit_admin, :reactivate_admin,:deactivate_admin, :destroy_admin]
  before_filter :authenticate_super_admin_login, only: [:new_admin, :admin_index, :admin_index_inactive, :edit_admin, :reactivate_admin,:deactivate_admin, :destroy_admin]

  def new_provider
    session[:provider_new_redirect_flag] = 1 #redirect flag used in providers#create
    @provider = Provider.new #Create new Provider object
  end

  def new_admin
    session[:admin_new_redirect_flag] = 1 #redirect flag used in providers#create
    @provider = Provider.new #Create new Provider object
  end

  def av_create_new_provider_and_assign_to_patient
    session[:provider_new_redirect_flag] = 2 #redirect flag used in providers#create
    session[:patient_provider_redirect_flag] = 2 #redirect flag used in patientproviders#create
    @provider = Provider.new
  end

  def index
    #Returns all active Provider records sorted by name
    @provider_array = Provider.all.where(active: true, admin: 0).order(provider_name: :asc)
  end

  def admin_index
    #Returns all active Provider records sorted by name
    @admin_array = Provider.all.where(active: true, admin: 1).order(provider_name: :asc)
  end

  def index_inactive
    #Returns all inactive Provider records sorted by name
    @inactive_provider_array = Provider.all.where(active: false, admin: 0).order(provider_name: :asc)
  end

  def admin_index_inactive
    #Returns all inactive Admin records sorted by name
    @inactive_admin_array = Provider.all.where(active: false, admin: 1).order(provider_name: :asc)
  end

  def list
    #redirect flag used in patientproviders#create
    session[:patient_provider_redirect_flag] = 2

    #Save current url, used for: back/cancel buttons in providers/av_create_new_provider_and_assign_to_patient.html.erb
    session[:provider_list_url] = request.original_url

    #Returns all active Provider records sorted by name
    @provider_list_array = Provider.all.where(active: true, admin: 0).order(provider_name: :asc)

    #Remove Providers that are already assigned to this Patient
    @provider_list_array -= Provider.where(id: Patientprovider.where(patient_id: params[:patient_id]).pluck(:provider_id))
  end

  def provider_list
    #Returns all active Provider records sorted by name
    @provider_list_array = Provider.all.where(active: true, admin: 0).order(provider_name: :asc)
  end

  def promote_to_admin
    provider = Provider.find_by(id: params[:provider_id]) #set the patient to inactive
    if provider.admin == 0
      provider.update(admin: 1)
      flash[:info] = 'Provider: ' + provider.provider_name + ' promoted to Admin'
      redirect_to sav_show_all_admins_path
    elsif provider.admin == 1
      flash[:error] = 'User: ' + provider.provider_name + ' is already an Admin'
      redirect_to :back
    else
      flash[:error] = 'User: ' + provider.provider_name + ' is not a Provider or an Admin'
      redirect_to :back
    end
  end

  def create
    @provider = Provider.new(provider_params)
    @provider.active = true
    @provider.admin = 0

    if session[:admin_new_redirect_flag] == 1
      @provider.admin = 1
    end

    if @provider.save #Try to write Patient record to DB. Returns true if successful.
      #If a patient id was supplied when writing to DB, route to create a patientprovider record as well.
      if params[:patient_id] ##Comes from av_create_new_provider_and_assign_to_patient_path
        redirect_to av_create_new_patientprovider_path(@provider.id, params[:patient_id])
      elsif session[:admin_new_redirect_flag] == 1
        session.delete(:admin_new_redirect_flag)
        if @provider.admin == 1
          flash[:success] = 'New Admin Created'
        elsif @provider.admin == 0
          flash[:success] = 'New Provider Created'
        end
        redirect_to sav_show_all_admins_path
      else
        flash[:success] = 'New Provider Created'
        redirect_to av_show_all_providers_path #else display provider index
      end
    else
      flash[:error] = 'Error Creating New Provider'

      #redirect based upon flag status
      if session[:provider_new_redirect_flag] == 1
        render 'new_provider'
      elsif session[:provider_new_redirect_flag] ==2
        render 'av_create_new_provider_and_assign_to_patient'
      elsif session[:admin_new_redirect_flag] == 1
        render 'new_admin'
      end
    end
  end

  def edit_provider
    @provider = Provider.find(params[:provider_id])

    #save provider name from the above query
    #original name is "lost" after an unsuccessful update
    session[:edit_provider_original_name] = @provider.provider_name
  end

  def edit_admin
    @provider = Provider.find(params[:admin_id])

    #save admin name from the above query
    #original name is "lost" after an unsuccessful update
    session[:edit_admin_original_name] = @provider.provider_name
  end

  def edit_self
    @provider = Provider.find(session[:self_provider_id])

    #save name from the above query
    #original name is "lost" after an unsuccessful update
    session[:edit_self_original_name] = @provider.provider_name

    session[:edit_self_admin_status] = @provider.admin
  end

  def update
    @provider = Provider.find_by(id: params[:id]) #set variable to existing record

    if session[:edit_provider_original_name] && !session[:edit_provider_original_name].nil?
      @provider.admin = 0

    elsif session[:edit_admin_original_name] && !session[:edit_admin_original_name].nil?
      case params["set_admin"].to_i
        when 1
          @provider.admin = 1
        when 0
          @provider.admin = 0
      end

    elsif session[:edit_self_admin_status] && !session[:edit_self_admin_status].nil?
      @provider.admin = session[:edit_self_admin_status]
    end

    if @provider.update(provider_params) #try to update current DB entry with new information, returns true if successful

      if session[:edit_provider_original_name] && !session[:edit_provider_original_name].nil?
        flash[:success] = 'Provider Updated'
        session.delete(:edit_provider_original_name)
        redirect_to av_show_all_providers_path

      elsif session[:edit_admin_original_name] && !session[:edit_admin_original_name].nil?
        flash[:success] = 'Admin Updated'
        session.delete(:edit_admin_original_name)
        redirect_to sav_show_all_admins_path

      elsif session[:edit_self_admin_status] && !session[:edit_self_admin_status].nil?
        flash[:success] = 'Account Updated'
        session.delete(:edit_self_admin_status)

        if session[:self_super_admin]
          redirect_to super_admin_home_path
        elsif session[:self_admin]
          redirect_to admin_home_path
        end
      end
    else
      if session[:edit_provider_original_name] && !session[:edit_provider_original_name].nil?
        flash[:error] = 'Error Updating Provider'
        render 'edit_provider'

      elsif session[:edit_admin_original_name] && !session[:edit_admin_original_name].nil?
        flash[:error] = 'Error Updating Admin'
        render 'edit_admin'

      elsif session[:edit_self_admin_status] && !session[:edit_self_admin_status].nil?
        flash[:error] = 'Error Updating Account'
        render 'edit_self'
      end
    end
  end

  def reactivate_provider
    provider = Provider.find_by(id: params[:id]) #set the patient to inactive
    if provider.admin == 0
      provider.update(active: true)
      flash[:info] = 'Provider: ' + provider.provider_name + ' Reactivated'
      redirect_to av_show_all_providers_path
    else
      flash[:error] = 'User: ' + provider.provider_name + ' is not a Provider'
      redirect_to :back
    end
  end

  def reactivate_admin
    admin = Provider.find_by(id: params[:id]) #set the patient to inactive
    if admin.admin == 1
      admin.update(active: true)
      flash[:info] = 'Admin: ' + admin.provider_name + ' Deactivated'
      redirect_to sav_show_all_admins_path
    else
      flash[:error] = 'User: ' + admin.provider_name + ' is not an Admin'
      redirect_to :back
    end
  end

  def deactivate_provider
    provider = Provider.find_by(id: params[:id]) #set the patient to inactive
    if provider.admin == 0
      provider.update(active: false)
      flash[:info] = 'Provider: ' + provider.provider_name + ' Deactivated'
      redirect_to av_show_all_providers_path
    else
      flash[:error] = 'User: ' + provider.provider_name + ' is not a Provider'
      redirect_to :back
    end
  end

  def deactivate_admin
    admin = Provider.find_by(id: params[:id]) #set the patient to inactive
    if admin.admin == 1
      admin.update(active: false)
      flash[:info] = 'Admin: ' + admin.provider_name + ' Deactivated'
      redirect_to sav_show_all_admins_path
    else
      flash[:error] = 'User: ' + admin.provider_name + ' is not an Admin'
      redirect_to :back
    end
  end

  def delete
    @provider = Provider.delete(params[:id]) #Delete the Provider record that matches the passed in id
    flash[:success] = 'Provider Deleted'
    redirect_to av_show_all_inactive_providers_path
  end

  def destroy_provider
    provider = Provider.find_by(id: params[:id]) #set the patient to inactive
    if provider.admin == 0
      provider = Provider.destroy(params[:id]) #Delete the Provider record that matches the passed in id
      flash[:info] = 'Provider: ' + provider.provider_name + ' Destroyed'  #and dependent records as well
      redirect_to av_show_all_inactive_providers_path
    else
      flash[:error] = 'User: ' + provider.provider_name + ' is not a Provider'
      redirect_to :back
    end
  end

  def destroy_admin
    admin = Provider.find_by(id: params[:id]) #set the patient to inactive
    if admin.admin == 1
      admin = Provider.destroy(params[:id]) #Delete the Provider record that matches the passed in id
      flash[:info] = 'Admin: ' + admin.provider_name + ' Destroyed'  #and dependent records as well
      redirect_to sav_show_all_inactive_admins_path
    else
      flash[:error] = 'User: ' + admin.provider_name + ' is not an Admin'
      redirect_to :back
    end
  end

  def show
    #Save current url, used for: back button in providers/list.html.erb
    #                            redirect after a successful patientprovider incident record creation
    session[:provider_show_url] = request.original_url
    session[:patient_provider_unassign_redirect_flag] = 2
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