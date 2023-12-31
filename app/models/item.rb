class Item < ApplicationRecord
  belongs_to :collection
  belongs_to :user
  has_many :taggables, dependent: :destroy
  has_many :tags, through: :taggables

  validates :item_name, presence: true
end
