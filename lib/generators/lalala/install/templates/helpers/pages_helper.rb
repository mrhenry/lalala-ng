module PagesHelper

  # Returns page by class name & puts it in an instance variable
  #
  # @param {Class} page_class
  #
  # @return {ApplicationPage}
  def get_page(page_class)
    key    = "@#{page_class.to_s.underscore.to_sym}"

    page   = instance_variable_get(key)
    page ||= instance_variable_set(key, page_class.first)
  end

end
