class Item < ApplicationRecord
  belongs_to :collection
  belongs_to :user
  has_many :taggables, dependent: :destroy
  has_many :tags, through: :taggables
  has_many :likes
  has_many :comments

  validates :item_name, presence: true
end
