# Spree::Admin::PromotionsController.class_eval do

#   protected
#   def collection
#     return @collection if defined?(@collection)
#     params[:q] ||= HashWithIndifferentAccess.new
#     params[:q][:s] ||= 'id desc'

#     @collection = super
#     @search = @collection.ransack(params[:q])
#     @collection = @search.result(distinct: true).
#       includes(promotion_includes).
#       page(params[:page])

#     @collection
#   end

# end