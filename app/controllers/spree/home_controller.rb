module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html, :json

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      @products = Spree::Product.search(params[:search])

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @products }
      end

    end
  end
end
