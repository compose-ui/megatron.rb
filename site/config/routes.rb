Rails.application.routes.draw do
  resources :demo, param: :page, path: 'demo'
  resources :errors, param: :page, path: 'errors'
  resources :docs, param: :page, path: ''
end
