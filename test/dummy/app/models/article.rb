class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category, :tag_ids

  # Translations
  translates :title, :body

  # Markdown
  markdown :body

  # Assets
  has_one_asset :poster_image, "images"
  has_many_assets :images, "images"
  has_many_assets :downloads, "downloads"

  # Validations
  validates :title, presence: true

  # Markdown columns
  markdown :body, tables: true, link_schemes: {
    "youtube" => Lalala::Markdown::Handlers::YouTube.new(width: 520, height: 292)
  }

  # Scopes
  scope :catA, where(:category => "A")
  scope :catB, where(:category => "B")
  scope :catC, where(:category => "C")

  # Bindings
  has_and_belongs_to_many :tags

  def get_tags
    self.tags
  end

end
