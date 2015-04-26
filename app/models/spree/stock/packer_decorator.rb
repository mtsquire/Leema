 module Spree
   module Stock
     Packer.class_eval do

      def default_package
        package = Package.new(stock_location, order)
        order.line_items.each do |line_item|
          if line_item.should_track_inventory?
            next unless stock_location.stock_item(line_item.variant)

            on_hand, backordered = stock_location.fill_status(line_item.variant, line_item.quantity)
            package.add line_item, on_hand, :on_hand if on_hand > 0
            # Added to allow backordered items to be shipped
            package.add line_item, on_hand, :on_hand if backordered > 0
            # package.add line_item, backordered, :backordered if backordered > 0
          else
            package.add line_item, line_item.quantity, :on_hand
          end
        end
        package
      end

     end