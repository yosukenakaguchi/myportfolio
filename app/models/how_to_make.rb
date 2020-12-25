class HowToMake < ApplicationRecord
  belongs_to :recipe
  validates :make_way, presence: true, length: { maximum: 255 }
end
