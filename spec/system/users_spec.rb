require 'rails_helper'

RSpec.describe "Users", type: :system do
    include UsersSpecHelper
    let!(:user) { create(:user, name:"Test User", email:"test@myportfolio.net", password:"123456", password_confirmation:"123456") }
    let!(:guest_user) { create(:user, name:"ゲストユーザー", email:"guest@myportfolio.net") }

    it "新規登録申請に成功する" do
        visit signup_path
        fill_in "user[name]", with: "テストユーザー"
        fill_in "user[email]", with: "signup-test@myportfolio.net"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_button "新規登録"
        expect(page).to have_content "送信したメールよりアカウントの有効化をおこなってください。"
        expect(current_path).to eq root_path
    end

    it "新規登録申請に失敗する" do
        visit signup_path
        fill_in "user[name]", with: ""
        fill_in "user[email]", with: ""
        fill_in "user[password]", with: ""
        fill_in "user[password_confirmation]", with: ""
        click_button '新規登録'
        #users_path?
        expect(current_path).to eq users_path
    end

    it "ログインする" do
        visit login_path
        fill_in "session[email]", with:"test@myportfolio.net" 
        fill_in "session[password]", with:"123456"
        click_button "ログイン"
        expect(page).to have_content 'ログインしました。'
        expect(current_path).to eq user_path(user)
    end

    it "ログインに失敗する" do
        visit login_path
        fill_in "session[email]", with:"wrong-email@myportfolio.net" 
        fill_in "session[password]", with:"wrongpassword"
        click_button "ログイン"
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        expect(current_path).to eq login_path
    end

    it "ログアウトする" do
        log_in(user)
        click_on "ログアウト"
        expect(page).to have_content 'ログアウトしました。'
        expect(current_path).to eq root_path
    end

    it "ユーザー情報を編集する" do
        log_in(user)
        visit edit_user_path(user)
        fill_in "user[name]", with: 'Edit Test User'
        fill_in "user[email]", with: 'edit_test@myportfolio.net'
        fill_in "user[password]", with: '654321'
        fill_in "user[password_confirmation]", with: '654321'
        click_button "変更を保存する"
        expect(page).to have_content "変更が保存されました。"
        expect(current_path).to eq user_path(user)
        visit edit_user_path(user)
        expect(page).to have_field 'user[name]', with: 'Edit Test User'
        expect(page).to have_field 'user[email]', with: 'edit_test@myportfolio.net'
        click_on "ログアウト"
        visit login_path
        fill_in "session[email]", with:"edit_test@myportfolio.net" 
        fill_in "session[password]", with:"654321"
        click_button "ログイン"
        expect(page).to have_content "ログインしました。"
    end

    it "ゲストユーザーとしてログインする" do
        visit root_path
        click_on "ゲストログイン（閲覧用）"
        expect(page).to have_content "ゲストユーザーとしてログインしました。"
        expect(current_path).to eq user_path(guest_user)
    end

    it "ゲストユーザーはユーザー情報を編集できない" do
        log_in(guest_user)
        visit edit_user_path(guest_user)
        fill_in "user[name]", with: '悪意のあるユーザー'
        fill_in "user[email]", with: 'malicious-guest@myportfolio.net'
        fill_in "user[password]", with: 'malicious'
        fill_in "user[password_confirmation]", with: 'malicious'
        click_button "変更を保存する"
        expect(page).to have_content "ゲストユーザーの変更・削除はできません。"
        expect(current_path).to eq user_path(guest_user)
        visit edit_user_path(guest_user)
        expect(page).to have_field 'user[name]', with: 'ゲストユーザー'
        expect(page).to have_field 'user[email]', with: 'guest@myportfolio.net'
    end

    it "フォローする" do
    end

    it "永続的セッションテスト" do
    end

    it "フレンドリーフォワーディングテスト" do
    end
end