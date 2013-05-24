if defined?(ActiveAdmin) and defined?(AdminUser)
  ActiveAdmin.register AdminUser do

    menu priority: 90, html_options: { class: 'icon-user_gray' }

    filter :name
    filter :email

    index do
      column :name
      column :email
      column :current_sign_in_at
      column :last_sign_in_at
      column :sign_in_count
      default_actions
    end

    form do |f|
      f.inputs "Admin Details" do
        f.input :name
        f.input :email
        f.input :password
        f.input :password_confirmation
      end
      f.actions
    end

  end
end
