module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html, :json

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      @product_search = Spree::Product.search(params[:search])

      if @product_search
        @products = Spree::Product.search(params[:search]).order("RANDOM()")
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @products }
        end
      else
        @products = {}
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @products }
        end
      end

    end
  end
end
