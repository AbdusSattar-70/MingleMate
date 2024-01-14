# app/models/collection.rb
class Collection < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :categorizables, dependent: :destroy
  has_many :categories, through: :categorizables
  has_many :items, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :categories, presence: true
end
