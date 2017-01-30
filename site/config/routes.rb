Rails.application.routes.draw do
  get :status, to: proc { [200, {}, ['']] }
  resources :demo, param: :page, path: 'demo'
  resources :errors, param: :page, path: 'errors'
  resources :docs, param: :page, path: ''
end
