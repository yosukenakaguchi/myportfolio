class CommentsController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comment_params)
    @comment.user_id = current_user.id
    render :index if @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    render :index if @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :recipe_id, :user_id)
  end
end
