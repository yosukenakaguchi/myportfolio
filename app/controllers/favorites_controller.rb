class FavoritesController < ApplicationController
  before_action :set_recipe, only: %i[create destroy]

  def index
    @recipes = current_user.favorite_recipes

    render @recipes
  end

  def create
    @favorite = Favorite.create(user_id: current_user.id, recipe_id: params[:recipe_id])
    @recipe.reload
  end

  def destroy
    favorite = Favorite.find_by!(user_id: current_user.id, recipe_id: params[:recipe_id])
    favorite.destroy
    @recipe.reload
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end
