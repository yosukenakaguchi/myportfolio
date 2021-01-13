FactoryBot.define do
  factory :tag do
    tag_name {Faker::Food.ingredient}
  end
end