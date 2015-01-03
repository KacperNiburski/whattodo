Whattodo::Application.routes.draw do
  root 'welcome#index'
  get "/whattodo" => "welcome#home"
  get "/result/:date/:activity/:money"=>"welcome#matchEvents"
  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout

  # ttp://api.localhost.com/events
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do 
      get '/create_token' => "events#create_token"
      resources :events
      get '/today' => "events#today"
      get '/party' => 'events#partyEvents'
      get '/tomorrow' => 'events#tomorrow'
      get '/all' => 'events#all'
      get '/curate' => 'events#curate', defaults: {format: 'html'}
      get '/approve' => 'events#approve', as: :approve, defaults: {format: 'js'}
      get '/unapprove' => 'events#unapprove', as: :unapprove, defaults: {format: 'js'}
      get '/approved' => 'events#approved'
    end
  end

end
