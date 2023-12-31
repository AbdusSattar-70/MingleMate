class Categorizable < ApplicationRecord
  belongs_to :collection
  belongs_to :category
end
