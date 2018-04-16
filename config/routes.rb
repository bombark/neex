Rails.application.routes.draw do

	root 'application#index'

	resources :groups do
		get "members"      => "groups#index_members"
		get "news"         => "groups#index_news"
		get "groups"       => "groups#index_groups"
		get "groups/new"   => "groups#local_new_group"
		get "projects"     => "groups#index_projects"
		get "projects/new" => "groups#local_new_project"
	end

	resources :articles
	resources :projects
	resources :units
	resources :users do
		get "friends"      => "users#index_friends"
		get "news"         => "users#index_news"
		get "groups"       => "users#index_groups"
		get "projects"     => "users#index_projects"
	end

	resources :places
	resources :people

	get "edges/addfriend" => "edges#user_add_friend"
	get "edges/delfriend" => "edges#user_del_friend"

	get "edges/follow"   => "edges#user_follow_node"
	get "edges/enter"    => "edges#user_enter_group"
	get "edges/visits"   => "edges#user_visits"
	get "edges/lives"    => "edges#user_lives"
	post "edges/update"   => "edges#update"

	get  "/login" => "sessions#new"
	post "/login" => "sessions#create"


	get "/home"               => "home#show"
	get "/home/:edge"         => "home#show"

	get "/home/contacts"      => "people#index"
	get "/home/contacts/new"  => "people#new"


	#get "/home/:p"  => "home#index"




	get "/node/:id"           => "public#show"
	#get "/node/:id/:edge" => "public#show_edge"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
