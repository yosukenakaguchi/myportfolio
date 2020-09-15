class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @recipe = current_user.recipes.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe.image.attach(params[:recipe][:image])
    if @recipe.save
      flash[:success] = "Recipe created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @recipe.destroy
    flash[:success] = "Recipe deleted"
    redirect_back(fallback_location: root_url)
  end

  private

    def recipe_params
      params.require(:recipe).permit(:content, :image)
    end


    def correct_user
      @recipe = current_user.recipes.find_by(id: params[:id])
      redirect_to root_url if @recipe.nil?
    end
end
