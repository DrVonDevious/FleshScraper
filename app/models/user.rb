class User < ActiveRecord::Base

  has_many :games

  has_secure_password

  validates :password, confirmation: true
  validates :password_confirmation, presence: true

end
