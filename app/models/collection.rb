# app/models/collection.rb
class Collection < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :categorizables, dependent: :destroy
  has_many :categories, through: :categorizables
  has_many :items, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :categories, presence: true

  pg_search_scope :search_by_title_description_category_item_user,
                  against: [:title, :description],
                  associated_against: {
                    user: [:user_name],
                    categories: [:name],
                    items: [:item_name]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
