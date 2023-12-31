class User < ApplicationRecord
  validates :user_name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :avatar, allow_nil: true
  validates :blocked, inclusion: { in: [true, false] }
end
