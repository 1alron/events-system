Rails.application.routes.draw do
  post '/entry', to: 'turnstile#entry'
  post '/entry', to: 'turnstile#exit'
  get  '/log',   to: 'logs#index'
end
