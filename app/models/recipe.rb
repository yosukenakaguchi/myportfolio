class Recipe < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :ingredients, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  has_many :how_to_makes, inverse_of: :recipe, dependent: :destroy
  accepts_nested_attributes_for :how_to_makes, reject_if: :all_blank, allow_destroy: true
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                              size: { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end