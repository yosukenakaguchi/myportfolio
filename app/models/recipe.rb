class Recipe < ApplicationRecord
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :how_to_makes, dependent: :destroy
  has_many :recipe_tag_relationships, dependent: :destroy
  has_many :tags, through: :recipe_tag_relationships

  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                                    size: { less_than: 5.megabytes,
                                            message: "should be less than 5MB" }

  has_one_attached :image

  # default_scope は本当に本当に必要なときのみ設定したほうがいいです
  default_scope -> { order(created_at: :desc) }

  def display_image
    image.variant(resize_to_fit: [300, 200])
  end

  def get_favorite(user_id)
    favorites.find_by(user_id: user_id)
  end
end
