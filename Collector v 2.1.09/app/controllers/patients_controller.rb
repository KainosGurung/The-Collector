class PatientsController < ApplicationController
  before_filter :authenticate_admin_login, except: :pv_patient_record_arrays
  before_filter :authenticate_provider_login, only: :pv_patient_record_arrays

  def new
    @patient = Patient.new #Create new Patient object
  end

  def av_create_new_patient_and_assign_to_provider
    session[:patient_provider_flag] = 1
    @patient = Patient.new
  end

  def index
    session[:duplicate_patient_show_behavior_flag] = 1
    #Returns all active Patient records sorted by name
    @patient_array = Patient.all.where(active: true).order(patient_name: :asc)
  end

  def index_inactive
    #Returns all active Patient records sorted by name
    @patient_array = Patient.all.where(active: false).order(patient_name: :asc)
  end

  def list
    session[:patient_provider_flag] = 1
    session[:patient_list_url] = request.original_url    #Save current url

    #Returns all active Patient records sorted by name
    @patient_array = Patient.all.where(active: true).order(patient_name: :asc)
    #Remove Patients that are already assigned to this Provider
    @patient_array -= Patient.where(id: Patientprovider.where(provider_id: params[:provider_id]).pluck(:patient_id))
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.active = true

    if @patient.save #Try to write Patient record to DB. Returns true if successful.

      #If a provider id was supplied when writing to DB, route to create a patientprovider record as well.
      if params[:provider_id] #Comes from av_create_new_patient_and_assign_to_provider_path
        redirect_to av_create_new_patientprovider_path(params[:provider_id], @patient.id)
      else
        redirect_to av_show_all_patients_path('*') #else redirect to index
      end
    else
      render 'error'
    end
  end

  def edit
    @patient = Patient.find(params[:patient_id])
    session[:edit_patient_original_name]= @patient.patient_name
  end

  def update
    @patient = Patient.find_by(id: params[:id]) #set variable to existing record

    if @patient.update(patient_params) #try to update current DB entry with new information, if unsuccessful then render error
      redirect_to av_show_all_patients_path
    else
      render 'edit_error'
    end
  end

  def reactivate
    patient = Patient.find_by(id: params[:id]) #reset the patient to active
    patient.update(active: true)
    redirect_to av_show_all_inactive_patients_path
  end

  def deactivate
    patient = Patient.find_by(id: params[:id]) #set the patient to inactive
    patient.update(active: false)
    redirect_to av_show_all_patients_path
  end

  def delete
    @patient = Patient.delete(params[:id]) #Delete the Patient record that matches the passed in id
    redirect_to av_show_all_inactive_patients_path
  end

  def destroy
    @patient = Patient.destroy(params[:id]) #Delete the Patient record that matches the passed in id
    redirect_to av_show_all_inactive_patients_path #and dependent records as well
  end

  def show
    session[:patient_show_url] = request.original_url    #Save current url
    session[:duplicate_patient_show_behavior_flag] = 0

    #Query Patientprovider table for records that match the provider id passed in.
    #Extract the patient ids from the returned records and
    #Query Patient table for records that match the ids from the first query and are active
    @patient_name_array = Patient.where(id: Patientprovider.where(provider_id: params[:provider_id]).pluck(:patient_id), active: true).order(patient_name: :asc)
  end

  def pv_patient_record_arrays
    #Query Patientprovider table for records in which the provider_id matches the provider_id of the provider that's logged in
    #Take only the patient ids from the returned records and store it
    session[:patient_id_array] = Patientprovider.where(provider_id: session[:self_provider_id]).pluck(:patient_id)
    session[:patient_name_array] = []


    for p in session[:patient_id_array]
      #Query Patient table for records in which the id matches the patient_id
      #Take only the active patient names from the returned records and store it
      session[:patient_name_array].push(Patient.where(id: p, active: true).pluck(:patient_name)[0])
    end

    temp = []
    for i in session[:patient_id_array]
      if session[:patient_name_array].include?(Patient.where(id: i).pluck(:patient_name)[0])
        temp.push(i)
      end
    end

    session[:patient_id_array] = temp

    redirect_to pv_behavior_record_arrays_path
  end

  private

  def patient_params
    params.require(:patient).permit(:patient_name)
  end
end