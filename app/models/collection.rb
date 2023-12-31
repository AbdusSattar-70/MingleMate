# app/models/collection.rb
class Collection < ApplicationRecord
  belongs_to :user
  has_many :categorizables, dependent: :destroy
  has_many :categories, through: :categorizables

  has_many :items, dependent: :destroy

end

