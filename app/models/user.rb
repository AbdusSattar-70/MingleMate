class User < ApplicationRecord
 include ActiveModel::SecurePassword
  has_secure_password

  attr_accessor :password_digest

  validates :user_name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :blocked, inclusion: { in: [true, false] }
end
