FactoryBot.define do
  factory :user do
    name { "Yosuke Nakaguchi" }
    sequence(:email) { |n| "test#{n}@myportfolio.net" }
    password { "password" }
    password_confirmation {"password" }
    activated { true }

    #名前が無し
    trait :name_nil do
      name { nil }
    end

    #名前が51字以上
    trait :name_more_than_50words do
      name { "a" * 51 }
    end

    #メールアドレスがなし
    trait :email_nil do
      email { nil }
    end

    #メールアドレスが256文字以上
    trait :email_more_than_255words do
      email {"a" * 240 + "@myportfolio.net"}
    end

    #パスワードがなし
    trait :no_password do
      password { " " * 6 }
      password_confirmation { " " * 6 }
    end

    #パスワードが5文字以下
    trait :password_less_than_6words do
      password{ "a" * 5 }
      password_confirmation{ "a" * 5 }
    end
  end
end
