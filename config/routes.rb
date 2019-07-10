Rails.application.routes.draw do
  post 'tests', to: 'tests#create'
  get 'tests/last', to: 'tests#show'
  get 'tests', to: 'tests#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
