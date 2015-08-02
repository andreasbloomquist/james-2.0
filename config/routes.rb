Rails.application.routes.draw do
  root 'construction#index'

  resources :brokers
  get '/home', to: 'welcome#index'
  post 'sms/received', to: 'sms#received', as: 'received'
  get 'leads/:response_url', to: 'leads#show', as: 'respond_to_lead'

  get 'leads/:resonse_url/thank-you', to: 'leads#thank_you', as:'thank_you'

  get '/admin', to: 'admin#index', as: 'admin'
  get '/login', to: 'sessions#new', as: 'login'
  post '/sessions', to: 'sessions#create'
  get '/logout', to: 'sessions#logout', as: 'logout'
  get '/authenticate', to: 'sessions#authenticate_broker', as: 'authenticate_broker'
  post '/authenticate', to: 'sessions#check_broker'

  get '/appointments/:availability_url/', to: 'appointments#show', as: 'schedule_appointment'
  get '/appointments/:availability_url/thank-you', to: 'appointments#thank_you', as: 'appointment_submitted'
  
  patch '/appointments/:availability_url', to: 'appointments#update', as: 'appointment'

  post '/properties/', to: 'properties#create', as: 'new_property'
  post '/properties/previous', to: 'properties#previous', as: 'previous_properties'

  get '/appointments/:user_cal_url/user', to: 'appointments#add_user_cal', as: 'user_calendar'
  get '/appointments/:broker_cal_url/broker', to: 'appointments#add_broker_cal', as: 'broker_calendar'
end
