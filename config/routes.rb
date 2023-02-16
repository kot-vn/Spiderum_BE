Rails.application.routes.draw do
  # devise_for :users
  post '/upload_image', to: 'application#upload_image'
  namespace :api do
    namespace :v1 do
      namespace :user1 do
        resources :users
        resources :users, only: %i[create update] do
          collection do
            post 'email_update'
          end
        end
        # put '/change_email', to: 'users#change_email'
        # post 'email_update', to: 'users#email_update'
        get 'confirm', to: 'users#confirm'
        post 'password/forgot', to: 'password#forgot'
        get 'password/reset', to: 'password#reset'
        put 'password/update', to: 'password#update'

        get '/edit', to: 'users#edit'
        get '/signup', to: 'users#new'
        post '/signup', to: 'users#create'

        # sessions controller
        get '/login', to: 'sessions#new'
        post '/login', to: 'sessions#create'
        delete '/logout', to: 'sessions#destroy'

        resource :users do
          get '/:id/feed', to: 'users#feed'
          get '/:id/my_favourites', to: 'users#my_favourites'
          get '/:id/my_posts', to: 'users#my_posts'
          get '/:id/search', to: 'users#search'
          get '/:id/search_to_mess', to: 'users#search_to_mess'
          put ':id/unban', to: 'users#unban'
        end

        resources :posts
        get '/posts/new', to: 'posts#new'
        get '/posts/edit', to: 'posts#edit'
        get '/posts', to: 'posts#index'
        get '/top', to: 'posts#top'
        get '/search', to: 'posts#search'

        resources :users do
          member do
            get :following, :followers
          end
        end

        resources :conversations do
          resources :messages
        end

        resource :relationships, only: %i[create destroy]

        resources :posts do
          resources :comments
        end

        resources :comments do
          resources :comments
        end

        resources :posts do
          resources :votes, only: %i[destroy]
          post 'votes/upvote', to: 'votes#upvote'
          post 'votes/downvote', to: 'votes#downvote'
        end

        resources :comments do
          resources :votes, only: %i[destroy]
          post 'votes/upvote', to: 'votes#upvote'
          post 'votes/downvote', to: 'votes#downvote'
        end

        resources :tags, only: %i[index create destroy show]

        resources :posts do
          resources :favourites, only: %i[create index destroy]
        end

        resources :notifications, only: %i[index show]

        resource :posts do
          post ':post_id/report', to: 'reports#create'
        end

        resource :comments do
          post ':comment_id/report', to: 'reports#create'
        end
        get '/reports', to: 'reports#index'
      end
    end
  end
end
