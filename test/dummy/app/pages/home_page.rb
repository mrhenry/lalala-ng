class HomePage < ApplicationPage

  self.route            = ''
  self.allow_create     = false
  self.allow_destroy    = false
  # self.minimum_children = nil
  # self.minimum_children = nil
  self.allowed_children = ['BasicPage']

  # form do |f|
  #   f.inputs
  #   f.buttons
  # end

  # def static_children
  #   {}
  # end
  #

end
