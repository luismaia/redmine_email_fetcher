# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

scope 'admin' do
  resources :email_configurations do
    get 'test', on: :member
    get 'fetch', on: :member
  end
end
