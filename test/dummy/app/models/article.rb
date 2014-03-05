class Article < ActiveRecord::Base
  attr_accessible :body, :title, :category, :tag_ids

  has_one_asset :image

  # Translations
  translates :title, :body

  # Validations
  validates :title, presence: true

  # Markdown columns
  markdown :body, tables: true, link_schemes: {
    "youtube" => Lalala::Markdown::Handlers::YouTube.new(width: 280, height: 157),
    "vimeo"   => Lalala::Markdown::Handlers::Vimeo.new()
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
