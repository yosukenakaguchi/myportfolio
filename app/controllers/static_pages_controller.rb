class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @recipe = current_user.recipes.build
      @recipes = current_user.feed.page(params[:page])
    end
  end

  def about
  end
end
