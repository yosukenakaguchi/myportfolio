class RecipesController < ApplicationController
  before_action :logged_in_user, only: %i[new edit update create destroy]
  before_action :check_valid_user,   only: %i[edit update destroy]

  def index
    if params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @search_recipes = @tag.recipes.page(params[:page]).per(15)
      @title = @tag.tag_name
    elsif params[:author]
      @search_recipes = Recipe.where(author: params[:author].to_s).page(params[:page]).per(15)
      @title = params[:author]
    elsif params[:work]
      @search_recipes = Recipe.where(work: params[:work].to_s).page(params[:page]).per(15)
      @title = params[:work]
    end
  end

  def new
    @recipe_form = RecipeForm.new
  end

  def show
    @recipe = Recipe.find(params[:id])
    @comment = Comment.new
    @comments = @recipe.comments.includes(:user)
  end

  def edit
    @recipe_form = RecipeForm.new(recipe: @recipe)
  end

  def update
    @recipe_form = RecipeForm.new(recipe_params, recipe: @recipe)
    if @recipe_form.save
      redirect_to @recipe, success: "レシピの編集が完了しました。"
    else
      render :edit
    end
  end

  def create
    @recipe_form = RecipeForm.new(recipe_params)
    if @recipe_form.save
      redirect_to root_url, success: "レシピの投稿が完了しました。"
    else
      render :new
    end
  end

  def destroy
    @recipe.destroy
    redirect_to root_url, success: "レシピを削除しました。"
  end

  private

  def recipe_params
    params.require(:recipe).permit(
      :title, :image, :content, :work, :author, :tag_name,
      ingredients_attributes: %i[ingredient amount _destroy_line],
      how_to_makes_attributes: %i[make_way _destroy_line]
    ).merge(user_id: current_user.id)
  end

  def check_valid_user
    @recipe = current_user.recipes.find_by(id: params[:id])
    redirect_to root_url if @recipe.nil?
  end
end
