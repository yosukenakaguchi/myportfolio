class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :edit, :upadate, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @recipes = Recipe.all.page(params[:page]).per(15)
    if params[:tag_name]
      @recipes = Recipe.tagged_with("#{params[:tag_name]}").all.page(params[:page]).per(15)
      @title = params[:tag_name]
    elsif params[:author]
      @recipes = Recipe.where(author: "#{params[:author]}").all.page(params[:page]).per(15)
      @title = params[:author]
    elsif params[:work]
      @recipes = Recipe.where(work: "#{params[:work]}").all.page(params[:page]).per(15)
      @title = params[:work]
    end
  end

  def new
    @recipe = current_user.recipes.build
    3.times { @recipe.ingredients.build }
    3.times { @recipe.how_to_makes.build }
  end
  
  def show
    @recipe = Recipe.find_by(id:params[:id])
    @comment = Comment.new
    @comments = @recipe.comments.includes(:user)
    if params[:tag_name]
      @recipes = Recipe.tagged_with("#{params[:tag_name]}").all.page(params[:page]).per(15)
    elsif params[:author]
      @recipes = Recipe.where(author: "#{params[:author]}").all.page(params[:page]).per(15)
    elsif params[:work]
      @recipes = Recipe.where(work: "#{params[:work]}").all.page(params[:page]).per(15)
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    @recipe.image.attach(params[:recipe][:image])
    if @recipe.update_attributes(recipe_params)
      flash[:success] = 'Recipe updated!'
      redirect_to @recipe
    else
    render 'edit'
    end
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe.image.attach(params[:recipe][:image])
    if @recipe.save
      flash[:success] = "Recipe created!"
      redirect_to root_url
    else
      @recipes = current_user.feed.page(params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @recipe.destroy
    flash[:success] = "Recipe deleted!"
    redirect_back(fallback_location: root_url)
  end

  private

    def recipe_params
      params.require(:recipe).permit(:title, :image, :content, :work, :author, :tag_list,
                                      ingredients_attributes: [:id, :ingredient, :amount, :_destroy],
                                      how_to_makes_attributes: [:id, :content, :_destroy])
    end

    def correct_user
      @recipe = current_user.recipes.find_by(id: params[:id])
      redirect_to root_url if @recipe.nil?
    end

    def get_category_children
      @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
   end
end
