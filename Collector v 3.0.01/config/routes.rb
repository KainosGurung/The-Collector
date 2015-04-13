Rails.application.routes.draw do
  #av = admin view
  #pv = provider view

  resources :behaviors, only: [:create, :update]
  resources :providers, only: [:create, :update]
  resources :patients, only: [:create, :update]
  resources :patientproviders, only: [:create, :update]
  resources :patientbehaviors, only: [:create, :update]

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

  get 'admin/incidents/index/graph_select/(:provider_id)/(:patient_id)/(:behavior_id)' => 'incidents#select_graph', as: :av_show_select_incident_graph
  get 'admin/incidents/index/graph' => 'incidents#graph', as: :av_show_incident_graph


  get 'admin/providers/index' => 'providers#index', as:  :av_show_all_providers
  get 'admin/providers/index/new' => 'providers#new_provider', as: :av_create_new_provider
  get 'admin/providers/index/deactivate_provider' => 'providers#deactivate_provider', as: :av_deactivate_provider
  get 'admin/providers/index/inactive' => 'providers#index_inactive', as: :av_show_all_inactive_providers
  get 'admin/providers/index/reactivate_provider' => 'providers#reactivate_provider', as: :av_reactivate_provider
  get 'admin/providers/index/inactive/destroy' => 'providers#destroy_provider', as: :av_destroy_provider
  delete 'admin/providers/index/delete' => 'providers#delete'
  get 'admin/providers/index/:provider_id/edit' => 'providers#edit_provider', as: :av_edit_provider
  get 'admin/edit_self' => 'providers#edit_self', as: :av_edit_self
  get 'admin/providers/index/individualproviders/:provider_name/:provider_id/individuals/show' => 'patients#show', as:  :av_show_patients
  get 'admin/providers/index/individualproviders/:provider_name/:provider_id/individuals/array' => 'patients#list', as: :av_show_all_patients_to_add_to_provider
  get 'admin/providers/index/individualproviders/provider/:provider_name/:provider_id/individual/create' => 'patients#av_create_new_patient_and_assign_to_provider', as: :av_create_new_patient_and_assign_to_provider



  get 'super_admin/home' => 'welcome#super_admin_home', as: :super_admin_home
  get 'super_admin/edit_self' => 'providers#edit_self', as: :sav_edit_self
  get 'super_admin/admins/index' => 'providers#admin_index', as: :sav_show_all_admins
  get 'super_admin/admins/index/provider_list' => 'providers#provider_list', as: :sav_show_all_providers_to_promote_to_admin
  get 'super_admin/admins/index/provider_list/promote_to_admin/:provider_id' => 'providers#promote_to_admin', as: :sav_promote_to_admin
  get 'super_admin/admins/index/new' => 'providers#new_admin', as: :av_create_new_admin
  get 'super_admin/admins/index/:admin_id/edit' => 'providers#edit_admin', as: :sav_edit_admin
  get 'super_admin/admins/index/inactive' => 'providers#admin_index_inactive', as: :sav_show_all_inactive_admins
  get 'super_admin/admins/index/inactive/destroy' => 'providers#destroy_admin', as: :sav_destroy_admin
  get 'super_admin/admins/index/deactivate_admin' => 'providers#deactivate_admin', as: :sav_deactivate_admin
  get 'super_admin/admins/index/reactivate_admin' => 'providers#reactivate_admin', as: :sav_reactivate_admin



  get 'admin/individuals/index' => 'patients#index', as: :av_show_all_patients
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

  get 'admin/behaviors/index' => 'behaviors#index', as: :av_show_all_behaviors
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
end
