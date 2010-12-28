Rails.application.routes.draw do
	resources :timed_tables, :controller => "timed_tables/timed_tables" do 
		member do
			post :update_rows
			get :at
			get :row_interval
		end
	end
	
	match 'timed_tables/:id/at/:jday.:format' => "timed_tables/timed_tables#at"
end

