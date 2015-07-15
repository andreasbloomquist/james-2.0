Rails.application.routes.draw do
  resources :brokers
  root 'welcome#index'
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
  patch '/appointments/:availability_url', to: 'appointments#update', as: 'appointment'

  post '/properties/', to: 'properties#create', as: 'new_property'
end
