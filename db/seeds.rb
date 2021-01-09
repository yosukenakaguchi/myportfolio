# メインのサンプルユーザーを1人作成する
User.create!(name:  "管理ユーザー",
             email: "admin@myportfolio.net",
             password:              "papipupepo",
             password_confirmation: "papipupepo",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

guest_password = User.new_token
User.create!(name:  "ゲストユーザー",
             email: "guest@myportfolio.net",
             password:              guest_password,
             password_confirmation: guest_password,
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
30.times do |n|
  name  = Faker::Japanese::Name.name
  email = "user-#{n+1}@myportfolio.net"
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
  ingredients_attributes = [Ingredient.new(ingredient: ingredient, amount: amount)]
  make_way = Faker::Food.description
  how_to_makes_attributes = [HowToMake.new(make_way: make_way)]
  split_tag_name = [title, ingredient]
  tags = split_tag_name.map { |name| Tag.find_or_create_by!(tag_name: name) }
  users.each { |user| user.recipes.create!(content: content, title: title, work: work, author: author, tags: tags, ingredients: ingredients_attributes, how_to_makes: how_to_makes_attributes) }
end

# 以下のリレーションシップを作成する
users = User.all
user  = users.second
following = users[2..30]
followers = users[3..20]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }