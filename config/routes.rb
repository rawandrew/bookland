Rails.application.routes.draw do
  scope :api do
    resources :books
    resource :authors
  end
end
