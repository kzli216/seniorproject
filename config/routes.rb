Seniorproject::Application.routes.draw do
	root :to => "home#index"

	devise_for :users, :controllers => {:registrations => "registrations"}
	resources :users do
		collection do
			get :autocomplete
		end
		member do
			get :following, :followers
		end
  	end

  	resources :goals do
		resources :records
		member do
			get 'inactivate'
			put 'inactivate'
		end
  	end

  	get '/change', to: 'home#change'
  	get "goals/:id/inactivate" => "goals#inactivate", :as =>"inactive_goal"

	resources :records
	resources :waters, controller: 'goals', type: 'Water' 
	resources :yogas, controller: 'goals', type: 'Yoga' 
	resources :exercises, controller: 'goals', type: 'Exercise'
	resources :journals, controller: 'goals', type: 'Journal' 
	resources :meditates, controller: 'goals', type: 'Meditate' 
	resources :runs, controller: 'goals', type: 'Run'
	resources :relationships, only: [:create, :destroy]
	resources :charges

end