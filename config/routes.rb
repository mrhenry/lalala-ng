Rails.application.routes.draw do

  #
  #  Active Admin & Devise
  #
  if (ActiveAdmin rescue nil)
    ActiveAdmin.routes(self)
    if (AdminUser rescue nil)
      devise_for :admin_users, ActiveAdmin::Devise.config
    end
  end


  #
  #  Assets
  #
  get '/lalala/assets/list'


  #
  #  Other
  #
  get '/lalala/markdown/cheatsheet', to: 'lalala/markdown#cheatsheet'


  #
  #  Errors
  #
  if (ErrorsController rescue nil)
    match '/404', to: 'errors#not_found'
    match '/422', to: 'errors#unprocessable_entity'
    match '/500', to: 'errors#internal_server_error'
  end

end
