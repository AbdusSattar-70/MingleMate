class Tag < ApplicationRecord
  has_many :taggables, dependent: :destroy
  has_many :items, through: :taggables

  validates :name, presence: true, uniqueness: true
end
