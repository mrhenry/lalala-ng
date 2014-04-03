module Formtastic
  class FormBuilder

    def input(method, options = {}, &block)
      options[:block] = block if block_given?
      super(method, options)
    end

  end
end
