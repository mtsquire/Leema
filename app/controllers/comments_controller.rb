class CommentsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def create
    @product = Product.find(params[:product_id])
    @comment = @product.comments.create(comment_params)
    @user = @comment.user
    redirect_to product_path(@product)
  end

  def destroy
    @product = Product.find(params[:product_id])
    @comment = @product.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to product_path(@product), notice: 'Comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:user_id, :body)
    end
end