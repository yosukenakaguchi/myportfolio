class RecipesController < ApplicationController
  before_action :logged_in_user, only: %i[new edit update create destroy]
  before_action :correct_user,   only: %i[edit update destroy]

  def index
    @recipes = Recipe.all.page(params[:page]).per(15)
    if params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @search_recipes = @tag.recipes.all.page(params[:page]).per(15)
      @title = @tag.tag_name
    elsif params[:author]
      @search_recipes = Recipe.where(author: params[:author].to_s).all.page(params[:page]).per(15)
      @title = params[:author]
    elsif params[:work]
      @search_recipes = Recipe.where(work: params[:work].to_s).all.page(params[:page]).per(15)
      @title = params[:work]
    end
  end

  def new
    @recipe_form = RecipeForm.new
  end

  def show
    @recipe = Recipe.find_by(id: params[:id])
    @comment = Comment.new
    @comments = @recipe.comments.includes(:user)
  end

  def edit
    @recipe_form = RecipeForm.new(recipe: @recipe)
  end

  def update
    @recipe_form = RecipeForm.new(recipe_params, recipe: @recipe)
    if @recipe_form.save
      flash[:success] = "レシピの編集が完了しました。"
      redirect_to @recipe
    else
      render :edit
    end
  end

  def create
    @recipe_form = RecipeForm.new(recipe_params)
    if @recipe_form.save
      flash[:success] = "レシピの投稿が完了しました。"
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    @recipe.destroy
    flash[:success] = "レシピを削除しました。"
    redirect_to root_url
  end

  private

  def recipe_params
    params.require(:recipe).permit(
      :title, :image, :content, :work, :author, :tag_name,
      ingredients_attributes: %i[ingredient amount _destroy_line],
      how_to_makes_attributes: %i[make_way _destroy_line]
    ).merge(user_id: current_user.id)
  end

  def correct_user
    @recipe = current_user.recipes.find_by(id: params[:id])
    redirect_to root_url if @recipe.nil?
  end
end
