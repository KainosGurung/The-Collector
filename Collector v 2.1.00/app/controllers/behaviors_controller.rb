class BehaviorsController < ApplicationController
  before_filter :authenticate_admin_login, except: :pv_behavior_record_arrays
  before_filter :authenticate_provider_login, only: :pv_behavior_record_arrays

  def new
    @behavior = Behavior.new #Create new Behavior object
  end

  def av_create_new_behavior_and_add_to_patient
    @behavior = Behavior.new
  end

  def index
    #Returns all active Behavior records sorted by name
    @behavior_array = Behavior.all.where(active: true).order(behavior_name: :asc)
  end

  def index_inactive
    #Returns all inactive Behavior records sorted by name
    @behavior_array = Behavior.all.where(active: false).order(behavior_name: :asc)
  end

  def list
    session[:behavior_list_url] = request.original_url  #Save current url

    #Returns all active Behavior records sorted by name
    @behavior_array = Behavior.all.where(active: true).order(behavior_name: :asc)
    #Remove Behaviors that are already assigned to this Patient
    @behavior_array -= Behavior.where(id: Patientbehavior.where(patient_id: params[:patient_id]).pluck(:behavior_id))
  end

  def create
    @behavior = Behavior.new(behavior_params)
    @behavior.active = true

    if @behavior.save #Try to write Behavior record to DB. Returns true if successful.

      #If a patient id was supplied when writing to DB, route to create a patientbehavior record as well.
      if params[:patient_id] #Comes from av_create_new_behavior_and_add_to_patient_path
        redirect_to av_create_new_patientbehavior_path(params[:patient_id], @behavior.id)
      else
        redirect_to av_show_all_behaviors_path #else display all behaviors
      end
    else
      render 'error'
    end
  end

  def edit
    @behavior = Behavior.find(params[:behavior_id])
    session[:edit_behavior_original_name] = @behavior.behavior_name
  end

  def update
    @behavior = Behavior.find_by(id: params[:id]) #set variable to existing record

    if @behavior.update(behavior_params) #try to update current DB entry with new information, if unsuccessful then render error
      redirect_to av_show_all_behaviors_path
    else
      render 'edit_error'
    end
  end

  def reactivate
    behavior = Behavior.find_by(id: params[:id]) #reset the behavior to active
    behavior.update(active: true)
    redirect_to av_show_all_inactive_behaviors_path
  end

  def deactivate
    behavior = Behavior.find_by(id: params[:id]) #set the behavior to inactive
    behavior.update(active: false)
    redirect_to av_show_all_behaviors_path
  end

  def delete
    Behavior.delete(params[:id]) #Delete the Behavior record that matches the passed in id
    redirect_to av_show_all_inactive_behaviors_path
  end

  def destroy
    Behavior.destroy(params[:id]) #Delete the Behavior record that matches the passed in id
    redirect_to av_show_all_inactive_behaviors_path   #and dependent records as well
  end

  def show
    session[:behavior_show_url] = request.original_url    #Save current url

    #Query Patientbehavior table for records that match the patient id passed in.
    #Extract the behavior ids from the returned records and
    #Query Behavior table for records that match the ids from the first query and are active
    @behavior_name_array = Behavior.where(id: Patientbehavior.where(patient_id: params[:patient_id]).pluck(:behavior_id), active: true).order(behavior_name: :asc)
  end

  def pv_behavior_record_arrays
      @behavior_id_array = []
      @behavior_name_array = []

      #Query Patientbehavior table for records that match the patient ids in the patient_id_array
      #This will return an array of records for each patient id. We then extract the behavior ids and store it
      for i in session[:patient_id_array]
        @behavior_id_array.push(Patientbehavior.where(patient_id: i).pluck(:behavior_id))
      end

      for j in @behavior_id_array #behavior_id_array is an array of arrays. Each inner array
        temp = []
        for k in j                         #correponds to a different patient
          #Query Behavior table for records that match the behavior ids in the inner arrays of patient_id_array
          #Extract only the active behavior names and store it
          name = Behavior.where(id: k, active: true).pluck(:behavior_name)[0]
          if name.present?
            temp.push(name)
          end
        end
        @behavior_name_array.push(temp)
      end
      temp2 = []
      @behavior_id_array.length.times do |n|
        temp1 = []
        for p in @behavior_id_array[n]
              if @behavior_name_array[n].include?(Behavior.where(id: p).pluck(:behavior_name)[0])
                temp1.push(p)
              end
        end
        temp2.push(temp1)
        #temp1.clear
      end
      @behavior_id_array = temp2
  end

  private

  def behavior_params
    params.require(:behavior).permit(:behavior_name, :behavior_description, :active)
  end
end
