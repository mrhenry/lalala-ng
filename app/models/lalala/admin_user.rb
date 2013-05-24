class Lalala::AdminUser < ActiveRecord::Base
  self.table_name     = 'admin_users'
  self.abstract_class = true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates :name,
    presence:   true,
    uniqueness: true

end
