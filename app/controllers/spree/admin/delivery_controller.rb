module Spree
  module Admin
    class DeliveryController < Spree::Admin::BaseController
    include ApplicationHelper
    before_filter :check_if_leema_admin_or_seller
      def edit
        @supplier = Spree::Supplier.friendly.find(params[:id])
        if @supplier.delivery_area
          @delivery_area = @supplier.delivery_area.tr('() ', '')
        end
      end

      private
        def location_after_save
          delivery_path(@supplier)
        end
    end
  end
end
