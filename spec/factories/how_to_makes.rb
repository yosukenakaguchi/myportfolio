FactoryBot.define do
  factory :how_to_make do
    make_way {Faker::Food.description}
  end
end
