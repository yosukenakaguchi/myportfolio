FactoryBot.define do
  factory :recipe do
    title {Faker::Food.dish}
    work {Faker::Book.title}
    author {Faker::Book.author}
    content {Faker::Lorem.sentence(word_count: 5)}
    association :user, factory: :user
    after(:build) do |recipe|
      recipe.ingredients << FactoryBot.build(:ingredient)
      recipe.ingredients << FactoryBot.build(:ingredient)
      recipe.ingredients << FactoryBot.build(:ingredient)
      recipe.how_to_makes << FactoryBot.build(:how_to_make)
      recipe.how_to_makes << FactoryBot.build(:how_to_make)
      recipe.how_to_makes << FactoryBot.build(:how_to_make)
      recipe.tags << FactoryBot.build(:tag)
      recipe.tags << FactoryBot.build(:tag)
      recipe.tags << FactoryBot.build(:tag)
    end
  end
end
