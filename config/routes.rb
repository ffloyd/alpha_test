Rails.application.routes.draw do
  root to: 'loans#index'

  resources :loans, except: [:edit, :update] do
    member do
      delete :remove_last_payment
      put :add_next_payment
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
