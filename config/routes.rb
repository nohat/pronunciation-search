Pron::Application.routes.draw do
  resources :words, :only => [:index, :show]
  resources :pronunciations, :only => [:index]
  root :to => "home#index"
end
