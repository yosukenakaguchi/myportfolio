class Ingredient < ApplicationRecord
  belongs_to :recipe
  validates :ingredient, presence: true, length: { maximum: 50 }
  validates :amount, presence: true, length: { maximum: 50 }
end
