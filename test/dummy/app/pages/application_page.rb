class ApplicationPage < Lalala::Page
  attr_accessible :images

  # All translated columns should be defined here:
  # translates :body

  # All page associations should be placed here:
  has_many_assets :images, :images

  markdown :body, tables: true, link_schemes: {
    "youtube" => Lalala::Markdown::Handlers::YouTube.new(width: 520, height: 292),
    "asset" => Lalala::Markdown::Handlers::Asset.new
  }

end
