Rails.application.routes.draw do

	  devise_for :users


  root 'home#top'
  get 'home/about'

  get "search" => "search#show"

  resources :users,only: [:show,:index,:edit,:update] do
    member do
  	get :following, :followers
  end
    patch :withdraw
  end


   	resources :relationships, only: [:create, :destroy]

  resources :books,only: [:new,:create,:index,:show,:edit,:update,:destroy] do
  	resources :book_comments, only: [:create, :destroy]
  	resource :favorites, only:[:create,:destroy]
  end
end
