class BasicPage < ApplicationPage

  # self.route             = nil # slug
  # self.allow_create      = true
  # self.allow_destroy     = true
  # self.minimum_children  = nil
  self.allowed_children  = ['BasicPage']

  # form do |f|
  #   f.inputs
  #   f.buttons
  # end

  # def static_children
  #   {}
  # end

end
