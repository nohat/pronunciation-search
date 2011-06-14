Pron::Application.routes.draw do
  resources :wordws

  resources :words, :only => [:index, :show]
  root :to => "home#index"
end
