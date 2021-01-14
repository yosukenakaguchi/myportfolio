class Recipe < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  # accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  has_many :how_to_makes, dependent: :destroy
  # accepts_nested_attributes_for :how_to_makes, reject_if: :all_blank, allow_destroy: true
  has_many  :recipe_tag_relationships, dependent: :destroy
  has_many  :tags, through: :recipe_tag_relationships
  default_scope -> { order(created_at: :desc) }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }

  def display_image
    image.variant(resize_to_fit: [300, 200])
  end

  def favorite_user(user_id)
    favorites.find_by(user_id: user_id)
  end
end
