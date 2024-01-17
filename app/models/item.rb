# app/models/item.rb
class Item < ApplicationRecord
  include PgSearch::Model
  belongs_to :collection
  belongs_to :user
  has_many :taggables, dependent: :destroy
  has_many :tags, through: :taggables
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :item_name, presence: true
  validates :tags, presence: true

  pg_search_scope :search,
                  against: [:item_name],
                  associated_against: {
                    user: [:user_name],
                    collection: %i[title description category],
                    tags: [:name],
                    comments: [:content]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
