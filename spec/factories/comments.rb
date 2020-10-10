FactoryBot.define do
  factory :comment do
    user { nil }
    recipe { nil }
    comment { "MyText" }
  end
end
