Rails.application.routes.draw do
  
  get 'sms/send'

  get 'welcome/index'
  root 'welcome#index'

  post 'sms/received', to: 'sms#received', as: 'received'

end
