FactoryBot.define do
  factory :recipe do
    title {Faker::Food.dish}
    work {Faker::Book.title}
    author {Faker::Book.author}
    content {Faker::Lorem.sentence(word_count: 5)}
      association :user, factory: :user
  end
end
