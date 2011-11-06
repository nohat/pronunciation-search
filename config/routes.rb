Pron::Application.routes.draw do
  resources :pronunciations, :only => [:index]
  root :to => "home#index"
end
