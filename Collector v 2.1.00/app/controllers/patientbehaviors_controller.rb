class PatientbehaviorsController < ApplicationController
  before_filter :authenticate_admin_login

  def new
    @patientbehavior = Patientbehavior.new  #Create new Patientbehavior object
  end

  def create
    @patientbehavior = Patientbehavior.new(patientbehavior_params)

    if @patientbehavior.save #Try to write Patientbehavior record to DB. Returns true if successful.
      redirect_to session[:behavior_show_url]
    else
      render 'error' #If unable to write Patientbehavior record to DB, render error page.
    end
  end

  def delete
    #Delete record in Patientbehavior table where the patient and behavior ids matches those passed in
    Patientbehavior.where(patient_id: params[:patient_id], behavior_id: params[:behavior_id]).delete_all
    redirect_to :back
  end

  private

  def patientbehavior_params
    params.permit(:patient_id, :behavior_id)
  end
end
