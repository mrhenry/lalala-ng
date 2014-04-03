Dummy::Application.routes.draw do
  get '/articles', to: 'pages#articles'

  pages :media, to: 'pages#media'
  pages :application, to: 'pages#show'
end
