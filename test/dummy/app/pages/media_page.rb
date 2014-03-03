class MediaPage < BasicPage

  self.route = "media"
  self.allow_create = false
  self.allow_destroy = false

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :images, as: :multiple_files do |h|
        h.inputs do
          h.input :title, as: :string
          h.input :choice, as: :select, collection: %w(A B C)
          h.input :check_it, as: :boolean
        end
      end
    end

    f.actions
  end

end
