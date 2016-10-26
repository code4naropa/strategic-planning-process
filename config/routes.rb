class AuthenticationConstraint

  # Signed-in users only
  def matches?(request)
    request.session[:user_id].present?
  end
end

Rails.application.routes.draw do

  # Registrations
  resource :signup, controller: 'registrations', as: 'registration', only: [:new, :create], path_names: { new: '' } do
    get 'confirm', on: :collection
    get 'confirmation_reminder', on: :collection
    post 'resend_confirmation', on: :collection, :constraints => { :format => 'js' }
  end

  # Sessions
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  # Posts
  resources :posts, only: [:new, :create, :show, :destroy], :path => "post"

  # Ideas
  resources :ideas, only: [:index, :create, :show, :destroy]

  # Like Path
  post '/:likable_type/:likable_id/like', to: 'likes#create', as: :like
  delete '/:likable_type/likable_id/like', to: 'likes#destroy', as: :unlike

  # Comment Path
  post '/:commentable_type/:commentable_id/comment', to: 'comments#create', as: :comment
  delete '/comments/:id', to: 'comments#destroy', as: :delete_comment

  # Conversations
  get 'conversations', to: 'feeds#show', as: :feed

  get '/about', to: 'static#about'
  get '/timeline', to: 'static#timeline'

  # Root is our community
  root 'democracy/communities#show'

end
