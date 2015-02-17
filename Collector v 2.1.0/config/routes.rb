Rails.application.routes.draw do
  #av = admin view
  #pv = provider view

  #----------Provider Views----------#
  get 'provider/home' => 'welcome#provider_home', as: :provider_home
  get 'provider/individuals' => 'patients#pv_patient_record_arrays', as:  :pv_patient_record_arrays
  get 'provider/individuals/behaviors/xl_show' => 'behaviors#pv_behavior_record_arrays', as: :pv_behavior_record_arrays
  get 'provider/individuals/behaviors/xl_show/help' => 'help#pv_behavior_record_arrays_help', as: :pv_behavior_record_arrays_help

  #----------both----------#
  get 'incidents/create/:provider_id/:patient_id/:behavior_id' => 'incidents#create', as: :add_incident

  #----------Admin views----------#
  get 'admin/home' => 'welcome#admin_home', as: :admin_home
  get 'admin/home/help' => 'help#admin_home_help', as: :admin_home_help
  get 'admin/incidents/index' => 'incidents#index', as: :av_show_all_incidents
  get 'admin/incidents/index_excel' => 'incidents#index_excel', as: :av_index_excel

  get 'admin/providers/index(:create_provider_success_flag)' => 'providers#index', as:  :av_show_all_providers
  get 'admin/providers/index/help' => 'help#providers_index_help', as:  :av_show_all_providers_help
  get 'admin/providers/index/new' => 'providers#new', as: :av_create_new_provider
  get 'admin/providers/index/deactivate' => 'providers#deactivate', as: :av_deactivate_provider
  get 'admin/providers/index/inactive' => 'providers#index_inactive', as: :av_show_all_inactive_providers
  get 'admin/providers/index/reactivate' => 'providers#reactivate', as: :av_reactivate_provider
  get 'admin/providers/index/inactive/destroy' => 'providers#destroy', as: :av_destroy_provider
  get 'admin/providers/error' => 'providers#error', as: :create_new_provider_error
  delete 'admin/providers/index/delete' => 'providers#delete'
  get 'admin/providers/index/:provider_id/edit' => 'providers#edit', as: :av_edit_provider

  get 'admin/providers/index/individualproviders/:provider_name/:provider_id/individuals/show' => 'patients#show', as:  :av_show_patients
  get 'admin/providers/index/individualproviders/:provider_name/:provider_id/individuals/array' => 'patients#list', as: :av_show_all_patients_to_add_to_provider
  get 'admin/providers/index/individualproviders/provider/:provider_name/:provider_id/individual/create' => 'patients#av_create_new_patient_and_assign_to_provider', as: :av_create_new_patient_and_assign_to_provider

  get 'admin/individuals/index(:create_patient_success_flag)' => 'patients#index', as: :av_show_all_patients
  get 'admin/individuals/index/help' => 'help#patients_index_help', as: :av_show_all_patients_help
  get 'admin/individuals/index/new' => 'patients#new', as: :av_create_new_patient
  get 'admin/individuals/index/deactivate' => 'patients#deactivate', as: :av_deactivate_patient
  get 'admin/individuals/index/inactive' => 'patients#index_inactive', as: :av_show_all_inactive_patients
  get 'admin/individuals/index/reactivate' => 'patients#reactivate', as: :av_reactivate_patient
  get 'admin/individuals/index/inactive/destroy' => 'patients#destroy', as: :av_destroy_patient
  delete 'admin/individuals/index/delete' => 'patients#delete'
  get 'admin/individuals/index/:patient_id/edit' => 'patients#edit', as: :av_edit_patient

  get 'admin/individuals/index/individualproviders/:patient_name/:patient_id/providers/show' => 'providers#show', as: :av_show_providers
  get 'admin/individuals/index/individualproviders/:patient_name/:patient_id/providers/array' => 'providers#list', as: :av_show_all_providers_to_add_to_patient
  get 'admin/individuals/index/individualproviders/individual/:patient_name/:patient_id/providers/create' => 'providers#av_create_new_provider_and_assign_to_patient', as: :av_create_new_provider_and_assign_to_patient

  get 'admin/individuals/index/individualbehaviors/:patient_name/:patient_id/behaviors/show' => 'behaviors#show', as: :av_show_behaviors
  get 'admin/individuals/index/individualbehaviors/:patient_name/:patient_id/behaviors/array' => 'behaviors#list', as: :av_show_all_behaviors_to_add_to_patient
  get 'admin/individuals/index/individualbehaviors/individual/:patient_name/:patient_id/behaviors/create' => 'behaviors#av_create_new_behavior_and_add_to_patient', as: :av_create_new_behavior_and_add_to_patient

  get 'admin/behaviors/index(:create_behavior_success_flag)' => 'behaviors#index', as: :av_show_all_behaviors
  get 'admin/behaviors/index/help' => 'help#behaviors_index_help', as: :av_show_all_behaviors_help
  get 'admin/behaviors/index/new' => 'behaviors#new', as: :av_create_new_behavior
  get 'admin/behaviors/index/deactivate' => 'behaviors#deactivate', as: :av_deactivate_behavior
  get 'admin/behaviors/index/inactive' => 'behaviors#index_inactive', as: :av_show_all_inactive_behaviors
  get 'admin/behaviors/index/reactivate' => 'behaviors#reactivate', as: :av_reactivate_behavior
  get 'admin/behaviors/index/inactive/destroy' => 'behaviors#destroy', as: :av_destroy_behavior
  delete 'admin/behaviors/index/delete' => 'behaviors#delete'
  get 'admin/behaviors/index/:behavior_id/edit' => 'behaviors#edit', as: :av_edit_behavior

  get 'admin/individualbehaviors/new/individual/:patient_id/behaviors/:behavior_id' => 'patientbehaviors#create', as: :av_create_new_patientbehavior
  get 'admin/individualbehaviors/delete/:patient_id/:behavior_id' => 'patientbehaviors#delete', as: :delete_patientbehavior

  get 'admin/individualprovider/new/providers/:provider_id/individual/:patient_id' => 'patientproviders#create', as: :av_create_new_patientprovider
  get 'admin/individualproviders/delete/:provider_id/:patient_id' => 'patientproviders#delete', as: :delete_patientprovider

  get 'log_in' => 'sessions#new', as: :log_in
  post 'log_in' => 'sessions#create'#, as: :log_in
  get 'log_out' => 'sessions#destroy'#, as: :log_out

  get '/' => 'welcome#index'
  root :to => 'welcome#index'

  resources :behaviors
  resources :providers
  resources :patients
  resources :patientproviders
  resources :patientbehaviors
  resources :sessions
end
