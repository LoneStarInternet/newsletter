Newsletter::Engine.routes.draw do

  resources :newsletters, except: [:show,:index] do
    member do 
      get :unpublish
      get :publish
      get :editor
    end
    collection do
      get :sort
    end
    resources :pieces, :only => [:new]
  end
  resources :pieces, :only => [:edit,:create,:update,:destroy]
  resources :designs do
    resources :elements, :only => [:index,:new,:create]
  end
  resources :elements, :only => [:edit,:create,:update,:destroy]

  match "/:newsletter_id/areas/:id/sort" => "areas#sort", :method => :get, as: 'sort_area'
  match '/newsletters/:id/:mode' => 'newsletters#show', :method => :get, :as => :public_newsletter_mode
  match '/newsletters/:id/public' => 'newsletters#show', :method => :get, :as => :public_newsletter
  match '/newsletters/:id' => 'newsletters#show', :method => :get, :as => :newsletter
  match '/newsletters' => 'newsletters#index', :method => :get, :as => :newsletters
  root :to => 'newsletters#index'
end

#public top-level routes
Rails.application.routes.draw do
  match '/newsletters/archive' => 'newsletter/newsletters#archive', :method => :get, :as => :newsletter_archive
  match '/newsletters/:id/:mode' => 'newsletter/newsletters#show', :method => :get, :as => :public_newsletter_mode
  match '/newsletters/:id/public' => 'newsletter/newsletters#show', :method => :get, :as => :public_newsletter
end
