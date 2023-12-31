# app/models/category.rb
class Category < ApplicationRecord
  has_many :categorizables, dependent: :destroy
  has_many :collections, through: :categorizables
end
