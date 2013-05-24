module Lalala::Pages::RouteMapper

  # pages(:about, to: 'about#show')
  # pages(:about, to: 'about#show') do
  #   get '/team/:member', to: 'about#team_member'
  # end
  # pages(:about) do
  #   get '/team/:member', to: 'about#team_member'
  # end
  def pages(*args)
    options = args.extract_options!
    options = options.dup

    unless args.size == 1 and Symbol === args[0]
      raise ArgumentError, "expected a page type"
    end

    type    = args[0]
    options = { as: type }.merge(options)
    options[:constraints] = Lalala::Pages::PageTypeConstraint.new(type)

    match '/', options

    if block_given?
      scope(options.except(:to,:action,:controller)) { yield }
    end

    self
  end

end
