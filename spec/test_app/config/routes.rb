Rails.application.routes.draw do
  mount Newsletter::Engine => "/newsletter", as: :news
end
