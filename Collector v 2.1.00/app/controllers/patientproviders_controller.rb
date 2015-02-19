class PatientprovidersController < ApplicationController
  before_filter :authenticate_admin_login

  def new
    @patientprovider = Patientprovider.new #Create new Patientprovider object
  end

  def create
    @patientprovider = Patientprovider.new(patientprovider_params)
    if @patientprovider.save #Try to write Patientprovider record to DB. Returns true if successful.
       if session[:patient_provider_flag] == 1
         session[:patient_provider_flag] = 0
         redirect_to session[:patient_show_url]
       elsif session[:patient_provider_flag] == 2
         session[:patient_provider_flag] = 0
         redirect_to session[:provider_show_url]
       end
    else
      render 'error' #If unable to write Patientprovider record to DB, render error page.
    end
  end

  def delete
    #Delete record in Patientprovider table where the patient and behavior ids matches those passed in
    Patientprovider.where(provider_id: params[:provider_id], patient_id: params[:patient_id]).delete_all
    redirect_to :back
  end

  private

  def patientprovider_params
    params.permit(:patient_id, :provider_id)
  end
end
