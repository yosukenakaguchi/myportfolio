require 'rails_helper'

RSpec.describe User, type: :model do
  it "ユーザー名、メールアドレス、パスワードがある場合、有効である" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "名前がなければ無効な状態である" do
    user = FactoryBot.build(:user, :name_nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "ユーザー名が５１文字以上の場合は登録できない" do
    user = FactoryBot.build(:user, :name_more_than_50words)
    user.valid?
    expect(user.errors[:name]).to include('is too long (maximum is 50 characters)')
  end

  it "メールアドレスがなければ無効な状態である" do
    user = FactoryBot.build(:user, :email_nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "メールアドレスが256文字以上の場合は登録できない" do
    user = FactoryBot.build(:user, :email_more_than_255words)
    user.valid?
    expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  it "メールアドレスが一意である" do
    user = FactoryBot.create(:user)
    duplicate_user = user.dup
    expect(duplicate_user).to be_invalid
  end

  it "メールアドレスがvalid_addressesの場合は登録できない" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      expect(FactoryBot.build(:user, email:valid_address)).to be_valid, "#{valid_address.inspect} should be invalid"
    end
  end

  it "メールアドレスがinvalid_addressesの場合は登録できない" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      expect(FactoryBot.build(:user, email:invalid_addresses)).to be_invalid, "#{invalid_address.inspect} should be valid"
    end
  end

  it "メールアドレスは小文字に変換されて登録される" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user = FactoryBot.create(:user, email:mixed_case_email)
    expect(mixed_case_email.downcase). to eq user.reload.email
  end

  it "パスワードがなければ無効な状態である" do
    user = FactoryBot.build(:user, :no_password)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "パスワードが5文字以下の場合は登録できない" do
    user = FactoryBot.build(:user, :password_less_than_6words)
    user.valid?
    expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
  end
end
