Rails.application.routes.draw do

	  devise_for :users


  root 'home#top'
  get 'home/about'


  resources :users,only: [:show,:index,:edit,:update]
  resources :books,only: [:new,:create,:index,:show,:edit,:update,:delete] do
  	resource :book_comments, only: [:create]
  end
end
