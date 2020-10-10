class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, counter_cache: :favorites_count
end
