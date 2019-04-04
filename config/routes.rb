Rails.application.routes.draw do
  get 'home/index'
  get '/name1' => 'home#name1'
  get '/name2' => 'home#name2'
  get '/name3' => 'home#name3'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
