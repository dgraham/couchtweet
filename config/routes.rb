# Routing details available at:
# http://guides.rubyonrails.org/routing.html
Couchtweet::Application.routes.draw do
  root :to => 'welcome#index'

  get  'signin'  => 'sessions#new'
  post 'signin'  => 'sessions#create'
  get  'signout' => 'sessions#destroy'

  get  'signup'  => 'users#new'
  post 'signup'  => 'users#create'

  resources '', :controller => :users, :only => %w[show edit update destroy], :as => :users do
    resources :followers, :only => [:index]
    resources :following, :only => [:index, :create, :destroy]
    resources :favorites, :only => [:index, :update, :destroy]
    resources :popular,   :only => [:index]
    resources :status,    :only => [:show, :create, :destroy], :as => :tweets
  end
end
