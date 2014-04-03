class HomePage < ApplicationPage

  # self.minimum_children  = nil
  self.route             = ''
  self.allow_create      = false
  self.allow_destroy     = false
  self.allowed_children  = ['BasicPage', 'MediaPage']

  # form do |f|
  #   f.inputs
  #   f.buttons
  # end

  def static_children
    {
      media: MediaPage.new
    }
  end

end
