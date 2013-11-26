class Tag < ActiveRecord::Base

  attr_accessible :title, :article_ids

  translates :title

  validates :title,
    presence: true

  # Bindings
  has_and_belongs_to_many :articles

end
