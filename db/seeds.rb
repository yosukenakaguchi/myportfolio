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
  ingredient1 = Faker::Food.ingredient
  ingredient2 = Faker::Food.ingredient
  ingredient3 = Faker::Food.ingredient
  amount1 = Faker::Food.measurement
  amount2 = Faker::Food.measurement
  amount3 = Faker::Food.measurement
  make_way1 = Faker::Food.description
  make_way2 = Faker::Food.description
  make_way3 = Faker::Food.description
  split_tag_name = [title, ingredient1]
  tags = split_tag_name.map { |name| Tag.find_or_create_by!(tag_name: name) }
  users.each {|user|
    user.recipes.create!(content: content, title: title, work: work, author: author, tags: tags,
                         ingredients: [
                          Ingredient.new(ingredient: ingredient1, amount: amount1),
                          Ingredient.new(ingredient: ingredient2, amount: amount2),
                          Ingredient.new(ingredient: ingredient3, amount: amount3)],
                         how_to_makes: [
                          HowToMake.new(make_way: make_way1),
                          HowToMake.new(make_way: make_way2),
                          HowToMake.new(make_way: make_way3)])}
end

# 以下のリレーションシップを作成する
users = User.all
user  = users.second
following = users[2..30]
followers = users[3..20]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }