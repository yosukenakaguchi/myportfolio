class Recipe < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_many :ingredients, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  has_many :how_to_makes, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :how_to_makes, reject_if: :all_blank, allow_destroy: true
  default_scope -> { order(created_at: :desc) }
  acts_as_taggable
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size: { less_than: 5.megabytes,
                              message: "should be less than 5MB" }
  validates :content, presence: true, length: { maximum: 255 }
  validates :work, presence: true, length: { maximum: 50 }
  validates :author, presence: true, length: { maximum: 50 }

  def display_image
    image.variant(resize_to_fit: [300, 200])
  end

  def favorite_user(user_id)
    favorites.find_by(user_id: user_id)
  end
end
