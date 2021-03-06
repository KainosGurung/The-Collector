class IncidentsController < ApplicationController
  before_filter :authenticate_provider_login

  def new
    @incident = Incident.new #Create new Incident object
  end

  def index
    @incident_array = Incident.all #Returns all Incident records
  end

  def index_excel
    @incident_array = Incident.all
    respond_to do |format|
      format.xls  #uses the built in .xls formater initialized at config/initializers/mime_types
    end
  end

  def create
    @incident = Incident.new(incident_params)

    if @incident.save   #Try to write Incident record to DB. Returns true if successful.
      flash[:success] = 'New Incident recorded'
    else
      flash[:error] = 'Create Incident error'
    end

    redirect_to :back
  end

  def graph
    @incident = Incident.all
  end

  private

  def incident_params
    params.permit(:provider_id, :patient_id, :behavior_id)
  end
end
