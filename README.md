# [映画・文学めし](https://www.myportfolio-app.net/)

映画や文学に登場する料理のレシピ投稿アプリです。

[https://www.myportfolio-app.net/](https://www.myportfolio-app.net/)

※ヘッダー右端に閲覧用のゲストログインボタンを設置しております。

## 概要

映画や文学において、時に料理は魅力的に描写されていますが、そういった料理の背後にある数多くの物語は既存のレシピサイトでは埋もれてしまっています。

映画や文学という従来のレシピサイトにはなかった新たな指標あれば、映画や文学を通して好きな料理が増え、また、好きな料理は更に好きになることができると思い、このポートフォリオを作成しました。

## 使用技術一覧

### フロントエンド

- Bootstrap 4.5.2
- haml
- Sass
- JavaScript, jQuery

### バックエンド

- Ruby 2.7.1
- Ruby on Rails 6.0.3.4
  - Rspec によるテスト
  - RuboCop による静的コード解析

### インフラ

- MySQL 8.0.21
- Nginx, Unicorn
- AWS（VPC | S3 | ELB | EC2 | Route53 | IAM | RDS(MySQL) | Cloud Watch）
- SendGrid
- Docker, Docker-compose(開発環境)

## インフラ構成図

![インフラ構成図](https://user-images.githubusercontent.com/67425779/99258575-1d620f00-285c-11eb-9073-c31442292060.png)

## 機能一覧

- ユーザー登録機能(SendGrid でのメールを介してアカウント有効化)
- ログイン・ログアウト機能
- ゲストログイン機能
- ログイン保持機能
- ユーザー情報編集機能
- パスワード再設定機能(SendGrid でのメールを介してパスワード再設定)
- 投稿機能
- 投稿タグ付け機能 (gem 'acts-as-taggable-on'を使用)
- 「作品」,「監督・著者」,「投稿」タグでの投稿絞り込み
- 投稿一覧・投稿詳細表示機能
- 投稿編集機能
- ページネーション機能（gem 'kaminari'を使用）
- お気に入り機能（Ajax 通信）
- コメント機能（Ajax 通信）
- フォロー・フォロワー機能 (Ajax 通信)
- 検索機能（gem 'ransack'を使用）

## 今後の課題・追加したい機能

- React による UI/UX の改善(現在、React を学習中)
- Rspec によるテスト追加
- ユーザーがタグをフォローできる機能  
  (映画・文学の嗜好性の指標でのユーザー間の交流を促す目的として)
- 投稿の作品または監督・著者別の五十音検索  
  (映画・文学の指標からレシピを検索できる UX の強化)
- 本番環境で AWS（ECR | ECS)を使用した Docker 環境での運用
- CircleCI/CD の導入
- Terraform の導入
