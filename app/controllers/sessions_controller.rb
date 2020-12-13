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
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが違います。"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = "ログアウトしました。"
    redirect_to root_url
  end

  def new_guest
    user = User.guest
    user.activate
    log_in user
    flash[:success] = "ゲストユーザーとしてログインしました。"
    redirect_to user
  end
end
