VDMSCode::Application.routes.draw do
  resources :people do
    collection do
      get :upload
      post :import
    end
    member { get :delete }
  end
  resources :events do
    member do
      get :delete
      get :join
      get :unjoin
    end
    resources :time_slots, :only => :index
    resources :constraints, :except => :show do
      member { get :delete }
    end
    resources :goals, :except => :show do
      member { get :delete }
    end
    resources :host_field_types, :except => :show do
      member { get :delete }
    end
    resources :visitor_field_types, :except => :show do
      member { get :delete }
    end
    resources :hosts do
      collection do
        get :join
        post :create_from_current_user
        delete :destroy_from_current_user
      end
      member { get :delete }
      resources :rankings, :controller => 'host_rankings', :only => :index do
        collection do
          get :add
          get :edit_all
          put :update_all
        end
      end
      resources :availabilities, :controller => 'host_availabilities', :except => :all do
        collection do
          get :edit_all
          put :update_all
        end
      end
      resources :meetings, :only => :index do
        collection do
          get :tweak
          post :apply_tweaks
        end
      end
    end
    resources :visitors do
      collection do
        get :join
        post :create_from_current_user
        delete :destroy_from_current_user
      end
      member { get :delete }
      resources :rankings, :controller => 'visitor_rankings', :only => :index do
        collection do
          get :add
          get :edit_all
          put :update_all
        end
      end
      resources :availabilities, :controller => 'visitor_availabilities', :except => :all do
        collection do
          get :edit_all
          put :update_all
        end
      end
      resources :meetings, :only => :index
    end
    resources :meetings, :only => :index do
      collection do
        post :generate
        get :create_all
        get :statistics
      end
    end
  end
  root :to => 'events#index'
end
