ActiveAdmin.register Article do

  scope :all, :default => true
  scope :catA
  scope :catB
  scope :catC

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :tags
      f.input :category, as: :select, collection: %w(A B C)
      f.input :images, as: :haraway do |h|
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
