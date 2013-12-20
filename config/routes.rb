# TexasHearingAids::Application.routes.draw do
#   #newsletters
#   match '/newsletters/archive' => 'newsletter/newsletters#archive', :method => :get, :as => :newsletter_archive
#   match '/newsletters/:id/:mode' => 'newsletter/newsletters#show', :method => :get, :as => :public_newsletter_mode
#   match '/newsletters/:id/public' => 'newsletter/newsletters#show', :method => :get, :as => :public_newsletter
#   match '/newsletters/:id' => 'newsletter/newsletters#show', :method => :get, :as => :newsletter
#   scope NewsletterPlugin::PATH_PREFIX.gsub(/^\//,''), :as => :newsletter do
#     resources :newsletters, module: 'newsletter' do
#       member do 
#         get :unpublish
#         get :publish
#       end
#       collection do
#         get :short
#       end
#       resources :pieces, module: 'newsletter', :only => [:index,:new,:create]
#     end
#     resources :pieces, module: 'newsletter', :only => [:edit,:create,:update,:destroy]
#     resources :designs, module: 'newsletter' do
#       resources :elements, :only => [:index,:new,:create], module: 'newsletter'
#     end
#     resources :elements, :only => [:edit,:create,:update,:destroy], module: 'newsletter'
#   end
#   match "#{NewsletterPlugin::PATH_PREFIX}/newsletters/:newsletter_id/areas/:id/sort" => "newsletter/areas#sort", :method => :get
# end