class User < ActiveRecord::Base
  extend Enumerize
  before_save :default_values

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enumerize :role, :in => [:guest, :user, :admin], scope: true, predicates: true

  has_many :ads, dependent: :destroy
  has_one :avatar, class_name: :Image, as: :imageable
  accepts_nested_attributes_for :avatar, :allow_destroy => true

  private

  def default_values
    self.role ||= "user"
  end
end
