Rails.application.routes.draw do
  resources :shipments, :only => [:create]
end
