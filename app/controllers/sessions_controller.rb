class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        flash[:success] = "ログインしました。"
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        redirect_to root_url, warning: "Account not activated. Check your email for the activation link."
      end
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが違います。"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, info: "ログアウトしました。"
  end

  def new_guest
    user = User.guest
    user.activate
    log_in user
    redirect_to user_url(user), success: "ゲストユーザーとしてログインしました。"
  end
end
