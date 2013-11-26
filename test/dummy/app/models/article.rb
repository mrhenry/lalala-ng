class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category, :images, :tag_ids

  # Translations
  translates :title, :body

  # Markdown
  markdown :body

  # Assets
  has_many_assets :images, :images

  # Validations
  validates :title, presence: true

  # Scopes
  scope :catA, where(:category => "A")
  scope :catB, where(:category => "B")
  scope :catC, where(:category => "C")

  # Bindings
  has_and_belongs_to_many :tags

end
