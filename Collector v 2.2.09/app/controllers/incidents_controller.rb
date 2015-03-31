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

  def select_graph
    session[:incident_select_url] = request.original_url

    @provider_array = Incident.select(:provider_id).distinct
    @patient_array = Incident.select(:patient_id).distinct
    @behavior_array = Incident.select(:behavior_id).distinct

    if params[:provider_id] != 'all' && !params[:provider_id].nil? && params[:provider_id] != '0'
      session[:graph_provider_id_name] = params[:provider_id]
      session[:graph_provider_id] = params[:provider_id]
    end
    if params[:patient_id] != 'all' && ! params[:patient_id].nil? && params[:patient_id] != '0'
      session[:graph_patient_id_name] = params[:patient_id]
      session[:graph_patient_id] = params[:patient_id]
    end
    if params[:behavior_id] != 'all' && !params[:behavior_id].nil? && params[:behavior_id] != '0'
      session[:graph_behavior_id_name] = params[:behavior_id]
      session[:graph_behavior_id] = params[:behavior_id]
    end

    if params[:provider_id] == '0'
      session[:graph_provider_id_name] = 'all'
      session[:graph_provider_id] =  Incident.select(:provider_id).distinct.pluck(:provider_id)
    end
    if params[:patient_id] == '0'
      session[:graph_patient_id_name] = 'all'
      session[:graph_patient_id] = Incident.select(:patient_id).distinct.pluck(:patient_id)
    end
    if params[:behavior_id] == '0'
      session[:graph_behavior_id_name] = 'all'
      session[:graph_behavior_id] = Incident.select(:behavior_id).distinct.pluck(:behavior_id)
    end

  end

  def graph
    @incident = Incident.where(provider_id: session[:graph_provider_id], patient_id: session[:graph_patient_id], behavior_id: session[:graph_behavior_id])
  end

  private

  def incident_params
    params.permit(:provider_id, :patient_id, :behavior_id)
  end
end
