Rails.application.routes.draw do
  
  root 'welcome#index'

  post 'sms/received', to: 'sms#received', as: 'received'

end
