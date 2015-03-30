class PatientbehaviorsController < ApplicationController
  before_filter :authenticate_admin_login

  def create
    @patientbehavior = Patientbehavior.new(patientbehavior_params)

    if @patientbehavior.save #Try to write Patientbehavior record to DB. Returns true if successful.
      flash[:success] = 'New Behavior Created'
      redirect_to session[:behavior_show_url]
    else
      flash[:error] = 'Error Creating New Patientbehavior'
      render 'error' #If unable to write Patientbehavior record to DB, render error page.
    end
  end

  def delete
    #Delete record in Patientbehavior table where the patient and behavior ids matches those passed in
    Patientbehavior.where(patient_id: params[:patient_id], behavior_id: params[:behavior_id]).delete_all
    redirect_to :back #TODO temp back path. delete function is never used at the moment
  end

  private

  def patientbehavior_params
    params.permit(:patient_id, :behavior_id)
  end
end
