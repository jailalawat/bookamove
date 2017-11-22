require 'sidekiq/web'

Rails.application.routes.draw do
  resources :messages_truck_available_calendars

  resources :truck_calendars

  resources :messages_staff_available_calendars

  resources :messages_task_calendars
  resources :staff_availables
  resources :messages_truck_calendars
  resources :subject_suggestions
  resources :truck_availables
  resources :email_alerts
  resources :payment_alerts
  resources :packing_alerts
  resources :equipment_alerts
  resources :time_alerts
  resources :access_alerts
  resources :cargo_alerts
  resources :move_source_alerts
  resources :move_keywords
  resources :move_webpages
  resources :move_referrals
  resources :move_sources
  resources :accounts
  resources :users
  resources :sessions
  resources :trucks
  resources :cities
  resources :city_locales
  resources :cargo_types
  resources :truck_sizes
  resources :move_types
  resources :clients
  resources :locations
  resources :move_records
  resources :taxes
  resources :config_parameters
  resources :profiles
  resources :calendar
  resources :calendar_tasks
  resources :calendar_truck_groups
  resources :calendar_staff_groups
  resources :subtask_staff_groups
  resources :personal_calendars
  resources :messages
  resources :roles
  resources :high_scores
  resources :messages_tasks
  resources :messages_move_records
  resources :reports
  resources :lead_report
  resources :customer
  resources :movers
  resources :move_type_alerts
  resources :contact_stages
  resources :customer_move_records

  #errors
  get 'errors/file_not_found' => 'errors#file_not_found'
  get 'errors/unprocessable' => 'errors#unprocessable'
  get 'errors/internal_server_error' => 'errors#internal_server_error'
  get 'errors/unauthorized' => 'errors#unauthorized'
  post 'errors/unauthorized' => 'errors#unauthorized'
  delete 'errors/unauthorized' => 'errors#unauthorized'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'sessions#index'

  post 'trucks/:id/upload_files/new' => 'image_trucks#create'
  delete 'trucks/:id/upload_files/destroy' => 'image_trucks#destroy'

  get 'home' => 'home#index'
  get 'forgot_password' => 'sessions#forgot_password'
  post 'forgot_password' => 'sessions#send_password_email'

  match '/login' => 'sessions#index', via: [:get, :post]
  get '/logout' => 'sessions#destroy'

  post 'edit_user_commissions/:id' => 'users#update_commission'

  post 'edit_commissions' => 'profiles#update_commission'
  get 'change_password' => 'profiles#change_password'

  get 'action_roles' => 'action_roles#index'
  get 'action_roles/get_actions' => 'action_roles#get_actions'
  post 'action_roles/new' => 'action_roles#create'
  delete 'action_roles/remove' => 'action_roles#destroy'

  get 'action_users' => 'action_users#index'
  get 'action_users/get_actions' => 'action_users#get_actions'
  post 'action_users/new' => 'action_users#create'
  delete 'action_users/remove' => 'action_users#destroy'

  # get 'role_users' => 'role_users#index'
  # get 'role_users/get_roles' => 'role_users#get_roles'
  # post 'role_users/new' => 'role_users#create'
  # delete 'role_users/remove' => 'role_users#destroy'

  post 'accounts/upload_files/new' => 'image_account#create'
  delete 'accounts/upload_files/destroy' => 'image_account#destroy'
  get 'list_accounts' => 'accounts#list'
  get 'accounts/:id/edit' => 'accounts#edit'
  post 'accounts/new' => 'accounts#create'
  post 'users/new' => 'users#create_by_account'
  patch 'accounts/:id/edit' => 'accounts#update_by_id'
  get 'fill_table_accounts_list' => 'accounts#fill_table_account_list'

  post 'upload_files/new' => 'image_profile#create'
  delete 'upload_files/destroy' => 'image_profile#destroy'

  #calendar move records
  get 'calendar_movers' => 'calendar#move_calendar_event'
  get 'truck_calendar_resources' => 'calendar#truck_calendar_resources'
  put 'update_time_calendar_movers' => 'calendar#move_calendar_update_time'
  put 'update_day_calendar_movers' => 'calendar#move_calendar_update_day'
  put 'update_add_man_movers' => 'calendar#move_calendar_update_add_man'
  get 'information_staff_truck' => 'calendar#staff_man_truck_by_move_record'
  post 'add_reminder_calendar_mover' => 'calendar#add_reminder_calendar_mover'
  delete 'destroy_reminder_calendar_mover' => 'calendar#destroy_reminder_calendar_mover'
  post 'add_truck_move_record' => 'calendar#move_calendar_select_truck'
  post 'add_truck_clone' => 'calendar#move_calendar_clone_move'

  #calendar tasks
  get 'calendar_task' => 'calendar_tasks#task_calendar_event'
  post 'add_subtask_group' => 'subtask_staff_groups#add_subtask_group'
  get 'task_calendar_resources' => 'calendar_tasks#task_calendar_resources'
  post 'add_staff_calendar_task' => 'calendar_tasks#add_staff_calendar_task'
  put 'update_day_calendar_tasks' => 'calendar_tasks#task_calendar_update_day'
  put 'update_time_calendar_tasks' => 'calendar_tasks#task_calendar_update_time'
  put 'update_task_information' => 'calendar_tasks#task_calendar_update_information'
  post 'add_reminder_calendar_task' => 'calendar_tasks#add_reminder_calendar_task'
  delete 'destroy_reminder_calendar_task' => 'calendar_tasks#destroy_reminder_calendar_task'
  delete 'destroy_staff_calendar_task' => 'calendar_tasks#destroy_staff_calendar_task'

  #personal calendar
  get 'calendar_personal' => 'personal_calendars#personal_calendar_event'
  post 'add_reminder_calendar_personal' => 'personal_calendars#add_reminder_calendar_personal'
  delete 'destroy_reminder_calendar_personal' => 'personal_calendars#destroy_reminder_calendar_personal'

  #truck calendar
  get 'calendar_truck' => 'truck_calendars#truck_calendar_event'
  post 'add_reminder_truck_calendar' => 'truck_calendars#add_reminder_truck_calendar'

  #contract settings
  get 'contract_settings' => 'move_record_contract_settings#index'
  put 'contract_settings' => 'move_record_contract_settings#update'

  #messages
  put 'update_readed_message' => 'messages#update_readed_message'
  delete 'destroy_message' => 'messages#destroy_message'
  post 'add_reply_message' => 'messages#add_reply_message'
  put 'mark_message' => 'messages#mark_message'

  #messages_tasks
  put 'update_readed_message_task' => 'messages_tasks#update_readed_message'
  delete 'destroy_message_task' => 'messages_tasks#destroy_message'
  post 'add_reply_message_task' => 'messages_tasks#add_reply_message'
  put 'mark_message_task' => 'messages_tasks#mark_message'

  #messages_move_record
  put 'update_readed_message_move_record' => 'messages_move_records#update_readed_message'
  delete 'destroy_message_move_record' => 'messages_move_records#destroy_message'
  post 'add_reply_message_move_record' => 'messages_move_records#add_reply_message'

  #messages_truck_calendar
  get 'update_messages_truck_calendar' => 'messages_truck_calendars#index_messages'

  #messages_task_calendar
  get 'update_messages_task_calendar' => 'messages_task_calendars#index_messages'


  #commission move record
  get 'commission_staff' => 'move_records#commission_by_staff'

  #reports
  get 'fill_table_post_report' => 'reports#fill_table_post_report'
  get 'post_reports' => 'reports#view_post'
  get 'fill_table_source_report' => 'reports#fill_table_source_report'
  get 'source_reports' => 'reports#view_source'
  get 'fill_table_card_batch_report' => 'reports#fill_table_card_batch_report'
  get 'card_batch_reports' => 'reports#view_card_batch'

  #clients autocomplete
  get 'client_information' => 'clients#client_information'

  #move section
  get 'fill_table_lead_report' => 'move_sections#fill_table_lead_report'
  get 'lead_reports' => 'move_sections#view_lead'
  get 'fill_table_quote_report' => 'move_sections#fill_table_quote_report'
  get 'quote_reports' => 'move_sections#view_quote'
  get 'fill_table_book_report' => 'move_sections#fill_table_book_report'
  get 'book_reports' => 'move_sections#view_book'
  get 'fill_table_dispatch_report' => 'move_sections#fill_table_dispatch_report'
  get 'dispatch_reports' => 'move_sections#view_dispatch'
  get 'fill_table_complete_report' => 'move_sections#fill_table_complete_report'
  get 'complete_reports' => 'move_sections#view_complete'


  #list move records
  get 'fill_table_list_move_record' => 'customer#fill_table_list_move_record'
  get 'fill_table_list_move_record_mover' => 'movers#fill_table_list_move_record_mover'

  #personal pages
  get 'fill_table_move_lead' => 'personal_pages#fill_table_move_lead'
  get 'move_lead' => 'personal_pages#view_lead'
  get 'fill_table_move_quote' => 'personal_pages#fill_table_move_quote'
  get 'move_quote' => 'personal_pages#view_quote'
  get 'fill_table_move_book' => 'personal_pages#fill_table_move_book'
  get 'move_book' => 'personal_pages#view_book'
  get 'fill_table_complete_book' => 'personal_pages#fill_table_complete_book'
  get 'move_complete' => 'personal_pages#view_complete'
  get 'review_responses' => 'personal_pages#view_review_responses'

  get 'fill_table_statement' => 'statement#fill_table_statement'
  get 'statement' => 'statement#view_statement'

  get 'search_move_record' => 'search#index'

  get 'furnishings_information' => 'move_records#furnishings_information'
  get 'cargo_template_information' => 'move_records#cargo_template_information'

  get 'stats' => 'stats#view_stats'
  get 'fill_table_stats' => 'stats#fill_table_stats'

  #move_record
  put 'update_contact_stages' => 'move_records#update_contact_stages'
  get 'template_email' => 'email_alerts#template_email'
  get 'public_info/:id' => 'api_processes#public_info'
  post 'messages_move_records_public' => 'api_processes#create_message_move_record_public'
  get 'send_review_request' => 'move_records#send_review_request'
  get 'send_review_request2' => 'move_records#send_review_request2'
  get 'send_review_thank_you' => 'move_records#send_review_thank_you'
  get 'send_complaint_response' => 'move_records#send_complaint_response'
  get 'send_confirmation' => 'move_records#send_confirmation'
  get 'get_subsource_by_source' => 'move_records#get_subsource_by_source'

  #api
  scope "/api/v1" do
    post 'move_records' => 'api_processes#create_external_move_record'
    post 'replicate_old_system_move' => 'api_processes#replicate_old_system_move'
  end

  #pdf printers
  get 'terms' => 'pdf_process#terms'
  get 'cargo' => 'pdf_process#cargo'
  get 'cc_consent' => 'pdf_process#cc_consent'
  get 'damage_claim' => 'pdf_process#damage_claim'
  get 'move' => 'pdf_process#move'
  get 'non_disclosure' => 'pdf_process#non_disclosure'
  get 'costs_and_surchage' => 'pdf_process#costs_and_surchage'

  #email pdf printers
  get 'cc_consent_mail' => 'mail_process#cc_consent'
  get 'follow_up_mail' => 'mail_process#follow_up'
  get 'move_mail' => 'mail_process#move'
  get 'non_disclosure_mail' => 'mail_process#non_disclosure'

  #truck available
  post 'update_truck_available_time' => 'truck_availables#update_truck_available_time'
  get 'calendar_truck_available' => 'truck_availables#calendar_truck_event'
  delete 'destroy_truck_available_time' => 'truck_availables#destroy_truck_available_time'

  #staff available
  post 'update_staff_available_time' => 'staff_availables#update_staff_available_time'
  get 'calendar_staff_available' => 'staff_availables#calendar_staff_event'
  delete 'destroy_staff_available_time' => 'staff_availables#destroy_staff_available_time'

  #calendars_lists
  get 'calendar_truck_available_list' => 'calendar#move_calendar_staff'
  get 'calendar_task_available_list' => 'calendar_tasks#move_calendar_staff'
  post 'task_calendar_available_time' => 'calendar_tasks#task_calendar_available_time'
  put 'task_calendar_available_time' => 'calendar_tasks#update_task_calendar_available_time'
  delete 'destroy_task_available_time' => 'calendar_tasks#destroy_task_available_time'
  get 'update_messages_staff_available_calendar' => 'messages_staff_available_calendars#index_messages'
  get 'update_messages_personal_calendar' => 'personal_calendars#index_messages'
  get 'update_messages_truck_available_calendar' => 'messages_truck_available_calendars#index_messages'
  get 'update_messages_my_truck_calendar' => 'truck_calendars#index_messages'


  #dropdowns contract settings
  get 'data_edit_dropdown' => 'move_record_contract_settings#data_edit_dropdown'
  post 'new_data_dropdown' => 'move_record_contract_settings#new_data_dropdown'
  put 'update_data_dropdown' => 'move_record_contract_settings#update_data_dropdown'

  #track group link
  get 'get_city_by_province' => 'cities#get_city_by_province'
  get 'get_locale_by_city' => 'city_locales#get_locale_by_city'
  get 'get_province_by_truck_group' => 'provinces#get_province_by_truck_group'
  get 'get_city_by_province_and_truck_group' => 'cities#get_city_by_province_and_truck_group'
  get 'get_locale_by_city_and_truck_group' => 'city_locales#get_locale_by_city_and_truck_group'

  #general settings
  get 'general_settings' => 'general_settings#index'
  patch 'general_settings' => 'general_settings#update'

  get 'remove_calendar_role' => 'calendar_staff_groups#remove_role'
  put 'assign_calendar_role' => 'calendar_staff_groups#assign_role'

  #contact stages
  post 'update_substage_positions' => 'contact_stages#update_substage_positions'
  post 'update_substage_enables' => 'contact_stages#update_substage_enables'
  post 'stages_attach_emails' => 'contact_stages#attach_emails'

  #email alerts
  post 'update_email_alert_enables' => 'email_alerts#update_email_alert_enables'
  post 'update_email_alert_autosend' => 'email_alerts#update_email_alert_autosend'
  post 'email_alerts_assign_stages' => 'email_alerts#assign_stages'
  post 'email_alerts_assign_stage' => 'email_alerts#assign_stage'
  get 'email_alerts_remove_stage' => 'email_alerts#remove_stage'

  #reviews
  get 'review_positive' => 'reviews#review_positive'
  get 'click_review_positive' => 'reviews#click_review_positive'
  get 'review_negative' => 'reviews#review_negative'
  post 'review_negative' => 'reviews#submit_review_negative'
  resources :review_links

  #referrals
  get 'referrals' => 'referrals#index'
  get 'add_email' => 'referrals#add_email'
  post 'email_link' => 'referrals#email_link'
  post 'create_referral' => 'referrals#create'


  get 'accounts_staff' => 'accounts#staff'
  get 'accounts_drivers' => 'accounts#drivers'

  get 'return_to_default_role_permissions' => 'roles#return_to_default_permissions'


  mount Sidekiq::Web, at: '/sidekiq'
  mount ActionCable.server => '/cable'

end
