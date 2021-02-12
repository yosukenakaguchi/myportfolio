class AccountActivationsController < ApplicationController
  # テストがほしいところ
  def edit
    user = User.find_by(email: params[:email])

    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      redirect_to user, success: "Account activated!"
    else
      redirect_to root_url, danger: "Invalid activation link"
    end
  end
end
