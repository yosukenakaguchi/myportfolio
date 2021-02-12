class Tag < ApplicationRecord
  has_many   :recipe_tag_relationships, dependent: :destroy
  has_many   :recipes, through: :recipe_tag_relationships

  validates :tag_name, presence: true
  validates :tag_name, uniqueness: { case_sensitive: true, allow_blank: true }
end
