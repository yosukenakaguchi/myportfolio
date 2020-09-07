class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @recipe = current_user.recipes.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def about
  end
end
