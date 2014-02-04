class User < ActiveRecord::Base
  validates :email, presence: true
  validates :password_digest, presence: true
  validates :full_name, presence: true

end
