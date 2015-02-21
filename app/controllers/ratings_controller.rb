class RatingsController < ApplicationController

  def create
    @rating = Rating.new(params[:rating])
    @product = Product.find(params[:rating][:product_id])

    respond_to do |format|
      if @rating.save
        format.json { render :json => { :avg_rating => @product.avg_rating } }
      else
        format.json { render :json => @rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @rating = Rating.find(params[:id])
    @product = Product.find(params[:rating][:product_id])
    @comment = @rating.comment
    @rating.update_attributes(params[:rating])
                
    respond_to do |format|
      if @rating.save
        format.json { render :json => { :avg_rating => @product.avg_rating } }
      else
        format.json { render :json => @rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  def rating_params
    params.require(:rating).permit(:score)
  end
end
