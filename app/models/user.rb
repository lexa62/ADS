class User < ActiveRecord::Base
  before_save :default_values
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  ROLES = %w[guest user admin]
  has_many :ads

  def default_values
    self.role ||= "user"
  end
end
