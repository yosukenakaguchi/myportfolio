class ApplicationController < ActionController::Base
  # SessionsHelper のメソッドはコントローラーに移したほうがいい
  include SessionsHelper

  before_action :set_search

  # Controllerのredirect_toをフラッシュメッセージを含めて1行で記載できる。
  add_flash_types :success, :info, :warning, :danger

  private

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url, danger: "Please log in."
    end
  end

  def set_search
    @search = Recipe.ransack(params[:q])
    @search_recipes = @search.result(distinct: true).order(created_at: :desc).page(params[:page]).per(15)
  end
end
