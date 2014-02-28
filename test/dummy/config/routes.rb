Dummy::Application.routes.draw do
  pages :media, to: 'pages#media'
  pages :application, to: 'pages#show'
end
