Spree::Shipment.class_eval do
  state_machine.before_transition :to => :shipped, :do => :buy_easypost_rate

  has_many :products, class_name: Spree::Product.to_s

  def tracking_url
    nil
  end

  private

  def selected_easy_post_rate_id
    selected_shipping_rate.easy_post_rate_id
  end

  def selected_easy_post_shipment_id
    selected_shipping_rate.easy_post_shipment_id
  end

  def easypost_shipment
    @ep_shipment ||= EasyPost::Shipment.retrieve(selected_easy_post_shipment_id)
  end

  def buy_easypost_rate
    rate = easypost_shipment.rates.find do |rate|
      rate.id == selected_easy_post_rate_id
    end

    easypost_shipment.buy(rate)
    self.tracking = easypost_shipment.tracking_code
    self.postage_label = easypost_shipment.postage_label.label_url
  end

  def easypost_tracker
    EasyPost::Tracker.retrieve(self.tracking)
  end


end
