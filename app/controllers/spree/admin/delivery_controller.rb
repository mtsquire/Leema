module Spree
  module Admin
    class DeliveryController < Spree::Admin::BaseController
      def edit
        @supplier = Spree::Supplier.friendly.find(params[:id])
        @delivery_area = @supplier.delivery_area.tr('() ', '')
      end

      private
        def location_after_save
          delivery_path(@supplier)
        end
    end
  end
end
