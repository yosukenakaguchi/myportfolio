FactoryBot.define do
  factory :ingredient do
    ingredient {Faker::Food.ingredient}
    amount {Faker::Food.measurement}
  end
end
