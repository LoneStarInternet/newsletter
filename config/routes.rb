Newsletter::Engine.routes.draw do

  resources :newsletters, except: [:show,:index] do
    member do 
      get :unpublish
      get :publish
    end
    collection do
      get :short
    end
    resources :pieces, :only => [:index,:new,:create]
  end
  resources :pieces, :only => [:edit,:create,:update,:destroy]
  resources :designs do
    resources :elements, :only => [:index,:new,:create]
  end
  resources :elements, :only => [:edit,:create,:update,:destroy]

  match "/:newsletter_id/areas/:id/sort" => "newsletter/areas#sort", :method => :get, as: 'sort_newsletter_area'
  match '/newsletters/archive' => 'newsletters#archive', :method => :get, :as => :newsletter_archive
  match '/newsletters/:id/:mode' => 'newsletters#show', :method => :get, :as => :public_newsletter_mode
  match '/newsletters/:id/public' => 'newsletters#show', :method => :get, :as => :public_newsletter
  match '/newsletters/:id' => 'newsletters#show', :method => :get, :as => :newsletter
  match '/newsletters' => 'newsletters#index', :method => :get, :as => :newsletter
  root :to => 'newsletters#index'
end
