require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "アカウント有効化" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "メールの件名が正しい状態であること" do
      expect(mail.subject).to eq("【映画・文学めし】アカウント有効化のお願い")
    end

    it "メールの宛先が正しい状態であること" do
      expect(mail.to).to eq([user.email])
    end

    it "メールの送信元が正しい状態であること" do
      expect(mail.from).to eq(["noreply@myportfolio-app.net"])
    end

    #テスト環境にはSMTPサーバーを立てていない為、メール本文が生成されない？
    #テスト環境にダミーSMTPサーバーを立てるか,統合テストとするか要検討https://sendgrid.kke.co.jp/blog/?p=10535
    skip it "メールの送信元が正しい状態であること" do
      expect(mail.body).to match("hi")
    end
  end
end
