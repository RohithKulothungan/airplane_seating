Rails.application.routes.draw do
  get 'welcome/index'

  resources :seatings

  root 'seatings#new'
end
