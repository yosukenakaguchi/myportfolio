class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【映画・文学めし】アカウント有効化のお願い"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "【映画・文学めし】パスワード再設定について"
  end
  
end