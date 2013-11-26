class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category, :images

  # Translations
  translates :title, :body

  # Markdown
  markdown :body

  # Assets
  has_many_assets :images, :images

  # Validations
  validates :title, presence: true

end
