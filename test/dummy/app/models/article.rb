class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category

  has_one_asset :image

  # Markdown
  markdown :body

  validates :title,
    presence: true

end
