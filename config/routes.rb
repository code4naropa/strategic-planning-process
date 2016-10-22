class AuthenticationConstraint

  # Signed-in users only
  def matches?(request)
    request.session[:user_id].present?
  end
end

Rails.application.routes.draw do

  # Registrations
  resources :registrations, only: [:new, :create] do
    get 'confirm', on: :collection
    post 'resend_confirmation', on: :collection, :constraints => { :format => 'js' }
  end

  # Sessions
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/confirm_your_registration' => 'registrations#confirmation_reminder', as: :confirm_registration_reminder

  # Posts
  resources :posts, only: [:new, :create, :show, :destroy], :path => "post"

  # Like Path
  post '/:likable_type/:likable_id/like', to: 'likes#create', as: :like
  delete '/:likable_type/likable_id/like', to: 'likes#destroy', as: :unlike

  # Comment Path
  post '/:commentable_type/:commentable_id/comment', to: 'comments#create', as: :comment
  delete '/comments/:id', to: 'comments#destroy', as: :delete_comment

  # Votes Path
  resources :votes, only: [:create, :update, :destroy], :path => "vote"

  # Conversations
  get 'conversations', to: 'feeds#show', as: :feed

  ### Democracy
  scope module: 'democracy', shallow: true do
    resources :communities, only: [:index, :show], module: 'community' do
      resources :decisions, only: [:index, :show, :new, :create]
    end
  end

  # Root is our community
  root 'democracy/communities#show'

end
