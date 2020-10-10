class HowToMake < ApplicationRecord
  belongs_to :recipe
  validates :content, presence: true, length: { maximum: 255 }
end
