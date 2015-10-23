module Spree
  module Admin
    class ReportsController < Spree::Admin::BaseController
      respond_to :html

      class << self
        def available_reports
          @@available_reports
        end

        def add_available_report!(report_key, report_description_key = nil)
          if report_description_key.nil?
            report_description_key = "#{report_key}_description"
          end
          @@available_reports[report_key] = {name: Spree.t(report_key), description: Spree.t(report_description_key)}
        end
      end

      def initialize
        super 
        ReportsController.add_available_report!(:sales_total)
      end

      def index
        @reports = ReportsController.available_reports
      end

      def sales_total
        params[:q] = {} unless params[:q]

        if params[:q][:completed_at_gt].blank?
          params[:q][:completed_at_gt] = Time.zone.now.beginning_of_month
        else
          params[:q][:completed_at_gt] = Time.zone.parse(params[:q][:completed_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
        end

        if params[:q] && !params[:q][:completed_at_lt].blank?
          params[:q][:completed_at_lt] = Time.zone.parse(params[:q][:completed_at_lt]).end_of_day rescue ""
        end

        params[:q][:s] ||= "completed_at desc"

        @search = Order.complete.ransack(params[:q])
        @orders = Spree::Order.complete
        @number_of_orders = @orders.count

        def get_shipment_profit(order)
          @shipment_profits = 0
          order.shipments.each do |shipment|
            # wrote this for any suppliers who had orders but then closed their account
            @shipment_total = 0
            shipment.line_items.each do |li|
              @shipment_total += (li.price * li.quantity)
            end
            if shipment.supplier
              @shipment_profits = @shipment_total * ((shipment.supplier.commission_percentage - 2.9) / 100)
            else
              @shipment_profits = @shipment_total * ((7.1) / 100)
            end
          end
          puts "@shipment_profits = #{@shipment_profits}"
          return @shipment_profits
        end

        @totals = {}
        @orders.each do |order|
          @profit_totals = get_shipment_profit(order)
          puts "profit for order #{@profit_totals}"
          @totals[order.currency] = { :item_total => ::Money.new(0, order.currency), :adjustment_total => ::Money.new(0, order.currency), :sales_total => ::Money.new(0, order.currency), :shipment_profit => 0 } unless @totals[order.currency]
          @totals[order.currency][:item_total] += order.display_item_total.money
          @totals[order.currency][:adjustment_total] += order.display_adjustment_total.money
          @totals[order.currency][:sales_total] += order.display_total.money
          @totals[order.currency][:shipment_profit] += @profit_totals
        end

      end

      private

      def model_class
        Spree::Admin::ReportsController
      end

      @@available_reports = {}

    end
  end
end
