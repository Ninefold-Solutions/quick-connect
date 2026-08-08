Rails.application.routes.draw do
  # Authentication routes
  get    'login',  to: 'sessions#new', as: :login
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"
  resources :user, except: %i[new edit show create]
  get '/reset' => 'user#reset', as: 'reset_user'
  get '/destroy' => 'user#destroy', as: 'destroy_user'
  get '/report', to: 'reports#index', as: 'reports'
  scope 'report' do
    get '/events', to: 'report/events#index', as: 'events_reports'
    get '/activities', to: 'report/activities#index', as: 'activities_reports'
    get '/groups', to: 'report/batches#index', as: 'batches_reports'
  end
  resources :contacts, except: [:show] do
    resources :notes, module: 'contact', except: %i[show new]
    resources :phone_calls, module: 'contact', except: %i[show new]
    resources :reminders, module: 'contact', except: %i[show new]
    resources :tasks, module: 'contact', except: [:new]
    resources :relatives, module: 'contact', except: %i[show new]
    resources :contact_activities, module: 'contact', except: %i[show new]
    resources :contact_events, module: 'contact', except: %i[show new]
    resources :about, module: 'contact', except: %i[show new create]
    resources :documents, module: 'contact', except: %i[show new]
    resources :links, module: 'contact', except: %i[show new index], as: 'social'
    resources :labels, module: 'contact', controller: 'contact_labels', only: %i[create destroy]

    collection do
      post :import
    end
    resources :gifts, module: 'contact', except: %i[show new]
    resources :batches, module: 'contact', path: 'groups', except: %i[show new update edit]
    resources :debts, module: 'contact', except: %i[show new]
    resources :conversations, module: 'contact', except: %i[show new]
    resources :timeline, module: 'contact', only: [:index]
  end
  get 'favorites', to: 'favorites#index', as: 'favorites'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/search/contacts', to: 'search#contacts'
  get '/search/contact', to: 'search#contact'
  get '/search/add', to: 'search#add'
  get '/search/nav', to: 'search#nav'
  root to: 'dashboard#index'
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  get 'followups', to: 'followups#index'
  get '/contacts/profile/:id', to: 'contacts#profile', as: 'contact_profile'
  scope '/settings' do
    get '/profile', to: 'user#profile', as: 'user_profile'
    get '/password', to: 'user#password', as: 'setting_password'
    patch '/password', to: 'user#update_password', as: 'change_password'
    get '/preferences', to: 'user#preferences', as: 'user_preferences'
  end
  put ':id/permission', to: 'user#update_permission', as: 'batch_permission'

  patch '/contacts/:contact_id/tasks/:id/toggle' => 'contact/tasks#toggle', as: 'toggle_task'
  # dashboard
  get :events, controller: :dashboard
  get :tasks, controller: :dashboard
  get :reminders, controller: :dashboard

  resources :batches, path: 'groups' do
    get 'contacts', to: 'batches#contacts', as: 'contacts'
    post '/add/:id', to: 'batches#add', as: 'addcontact'
    delete '/remove/:id', to: 'batches#remove', as: 'removecontact'
  end
  namespace :account do
    resources :relations, except: %i[new show]
    resources :labels, except: %i[new show]
    resource :group_buckets, only: %i[show update]
    resources :fields, except: %i[show new]
    resources :activities, except: %i[show new]
    resources :life_events, except: %i[show new]
    get '/export', to: 'export#index', as: 'export_contacts'
    get '/import', to: 'import#index', as: 'import_contacts'
    resources :users, except: %i[show new edit update destroy] do
      get '/deactivate', to: 'users#deactivate', as: 'deactivate'
      get '/activate', to: 'users#activate', as: 'activate'
    end
  end
  scope 'archive' do
    get '/contacts', to: 'contacts#archived', as: 'archived_contacts'
    get '/contact/:id', to: 'contacts#archive_contact', as: 'archive_contact'
    get '/contact/:id/restore', to: 'contacts#unarchive_contact', as: 'unarchive_contact'
  end
  scope 'untracked' do
    get '/contacts', to: 'contacts#untracked', as: 'untracked_contacts'

    get '/contact/:id/track', to: 'contacts#track', as: 'track_contact'
    get '/contact/untrack/:id', to: 'contacts#untrack', as: 'untrack_contact'
    get '/contact/touch_back/:id', to: 'contacts#touch_back', as: 'touch_back_contact'
  end
  get '/contact/:id', to: 'contacts#touched', as: 'touched_contact'
  get '/contact/:id/update_touched', to: 'contacts#update_touched', as: 'update_touched_contact'
  resources :collections, except: %i[new show]
  get '/search/collection', to: 'search#collection'
  post 'collections/:collection_id/add/:batch_id', to: 'collections#add_group', as: 'collection_add_batch'
  delete '/collection/:id/group/:batch_id', to: 'collections#remove_group', as: 'delete_collection_group'

  patch '/contacts/:contact_id/toggle_favorite', to: 'contact/base#toggle_favorite', as: 'toggle_favorite_contact'
end
