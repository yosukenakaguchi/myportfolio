require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "アカウント有効化" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user).deliver_now }

    it "メールの件名が正しい状態であること" do
      expect(mail.subject).to eq("【映画・文学めし】アカウント有効化のお願い")
    end

    it "メールの宛先が正しい状態であること" do
      expect(mail.to).to eq([user.email])
    end

    it "メールの送信元が正しい状態であること" do
      expect(mail.from).to eq(["noreply@myportfolio-app.net"])
    end

    it "メール本文中にユーザー名が表示されていること" do
      expect(mail.html_part.body).to match user.name
      expect(mail.text_part.body).to match user.name
    end
  end
end
