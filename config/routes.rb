Evergreen::Application.routes.draw do
  root to: "home#index"

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end    

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }

  get "login_redirect" => "application#login_redirect", as: "login_redirect"

  namespace :admin do
    resources :companies, path: "/c", shallow: true do
      delete :delete_logo
      delete :delete_favicon      
      
      resources :questions, path: "discussions"
      resources :answers
      resources :tags

      resources :links do
        patch :batch_update, on: :collection
      end
      
      resources :team_members do
        patch :batch_update, on: :collection
      end
      
      resources :users do
        delete :delete_avatar
      end      
    end
  end


  resources :companies, path: "/c", shallow: true do
    resources :questions, path: "discussions" do
      match :votes, via: [:post, :delete]
      match :accepted_answer, via: [:post, :delete], on: :member
      get "search", on: :collection
    end
    resources :answers do
      match :votes, via: [:post, :delete]
    end
    resources :comments do
      match :votes, via: [:post, :delete]
    end
    
    resources :tags
    resources :question_tags
  end

  resources :users do
    delete :delete_avatar, on: :member
  end

  resources :votes, only: [:index]
end
