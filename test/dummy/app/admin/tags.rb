ActiveAdmin.register Tag do
  # menu priority: 50, html_options: { class: 'icon-tag-purple' }

  form do |f|
    f.inputs do
      f.input :title
    end

    f.actions
  end

end
