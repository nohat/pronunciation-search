Pron::Application.routes.draw do
  resources :words, :only => [:index, :show]
  root :to => "home#index"
end
