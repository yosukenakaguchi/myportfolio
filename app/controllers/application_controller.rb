class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_search

def set_search
  @search = Recipe.ransack(params[:q])
  @search_recipes = @search.result(distinct: true).order(created_at: "DESC").page(params[:page]).per(15)
end

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end