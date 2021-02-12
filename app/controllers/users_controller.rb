class UsersController < ApplicationController
  before_action :check_valid_user, only: %i[edit update]
  before_action :admin_user,       only: :destroy
  before_action :logged_in_user,   only: %i[index edit update destroy following followers]
  before_action :check_guest,      only: %i[update destroy]

  def index
    @users = User.activated.page(params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      redirect_to root_url, info: '送信したメールよりアカウントの有効化をおこなってください。'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, success: "変更が保存されました。"
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_url, success: "User deleted"
  end

  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render :show_follow
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # beforeアクション

  # 正しいユーザーかどうか確認
  def check_valid_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def check_guest
    if current_user.email == User::GUEST_EMAIL
      redirect_to current_user, danger: 'ゲストユーザーの変更・削除はできません。'
    end
  end
end
