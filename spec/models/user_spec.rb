require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(
      name: "Yosuke Nakaguchi",
      email: "yosuke.nakaguchi@gmail.com"
      )
  end

  it "is invalid without a name" do
    @user.name = nil
    @user.valid?
    expect(@user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a email" do
    @user.email = nil
    @user.valid?
    expect(@user.errors[:email]).to include("can't be blank")
  end

  it "ユーザー名が５１文字以上の場合は登録できない" do
    @user.name = "a" * 51
    @user.valid?
    expect(@user.errors[:name]).to include('is too long (maximum is 50 characters)')
  end
  
  it "emailが256文字以上の場合は登録できない" do
    @user.email = "a" * 244 + "@example.com"
    @user.valid?
    expect(@user.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  it "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      expect(@user). to be_valid, "#{valid_address.inspect} should be invalid"
    end
  end

  it "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com] 
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      expect(@user). to be_invalid, "#{invalid_address.inspect} should be valid"
    end
  end

  it "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    expect(duplicate_user). to be_invalid
  end

  it "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    expect(mixed_case_email.downcase). to eq @user.reload.email
  end
end
  