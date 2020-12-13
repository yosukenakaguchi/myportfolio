FactoryBot.define do
  factory :recipe do
    title {"あああああ"}
    work {"あああああ"}
    author {"あああああ"}
    content {"あああああ"}
    association :user, factory: :user
  end
end
