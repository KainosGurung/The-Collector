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
      flash[:danger] = 'New Incident recorded'
      redirect_to :back
    else
      flash[:danger] = 'Create Incident error'
    end
  end

  def graphing
    @incident_all = Incident.all
    @provider_all = Incident.select(:provider_id).distinct
    @provider_array =@provider_all.all.map{|t|[t.provider_id, t.provider.provider_name]}

    @patient_all = Incident.select(:patient_id).distinct
    @patient_array =@patient_all.all.map{|t|[t.patient_id, t.patient.patient_name]}

    @behavior_all = Incident.select(:behavior_id).distinct
    @behavior_array =@behavior_all.all.map{|t|[t.behavior_id, t.behavior.behavior_name]}

    @provider_record = params[:provider]
    @patient_record = params[:patient]
    @behavior_record = params[:behavior]

    if @provider_record == "0"
      if @patient_record == "0"
        if @behavior_record == "0"
          @incident_array = @incident_all.all # all incidents
        else
          @incident_array = @incident_all.where(behavior_id: params[:behavior]) # only behavior
        end
      else
        if @behavior_record == "0"
          @incident_array = @incident_all.where(patient_id: params[:patient])#only patient
        else
          @incident_array = @incident_all.where(patient_id: params[:patient],behavior_id: params[:behavior]) #patient & behavior
        end
      end
    else
      if @patient_record == "0"
        if @behavior_record == "0"
          @incident_array =@incident_all.where(provider_id: params[:provider]) # only provider
        else
          @incident_array =@incident_all.where(provider_id: params[:provider], behavior_id: params[:behavior]) #provider & behavior
        end
      else
        if @behavior_record == "0"
          @incident_array =@incident_all.where(provider_id: params[:provider], patient_id: params[:patient]) # provider & patient
        else
          @incident_array = @incident_all.where(provider_id: params[:provider],patient_id: params[:patient],behavior_id: params[:behavior]) #provider & patient & behavior
        end
      end
    end

    if @incident_array == nil
      redirect_to  no_record_path
    end


  end



  private

  def incident_params
    params.permit(:provider_id, :patient_id, :behavior_id)
  end

end