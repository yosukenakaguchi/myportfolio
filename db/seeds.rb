# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  title = Faker::Food.dish
  work = Faker::Book.title
  author = Faker::Book.author
  ingredient = Faker::Food.ingredient
  amount = Faker::Food.measurement
  how_to_make = Faker::Food.description
  users.each { |user| user.recipes.create!(content: content, title: title, work: work, author: author,
                                           ingredients_attributes:[ingredient: ingredient, amount: amount],
                                           how_to_makes_attributes:[content: how_to_make]) }
end

# 以下のリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }