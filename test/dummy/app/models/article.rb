class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category

  has_one_asset :image

  # Translations
  translates :title, :body

  # Markdown
  markdown :body

  # Validations
  validates :title, presence: true

end
