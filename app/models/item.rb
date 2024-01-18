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
                  against: %i[item_name custom_fields],
                  associated_against: {
                    user: [:user_name],
                    collection: %i[title description custom_fields],
                    category: [:name],
                    tags: [:name],
                    comments: [:content]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
