Spree::Shipment.class_eval do
  require "open-uri"
  state_machine.before_transition :to => :shipped, :do => :buy_easypost_rate

  has_many :products, class_name: Spree::Product.to_s
  has_attached_file :leema_label, processors: [:leema_watermark], :styles => {:original => {}}
  validates_attachment_content_type :leema_label, :content_type => /\Aimage\/.*\Z/

  # takes the postage label from easypost and stores it in our db. then our watermark processor
  # is triggered
  def leema_label_from_url(url)
    self.leema_label = URI.parse(url)
    self.save!
  end

  #override this method from spree_drop_ship
  def supplier_commission_total
    ((self.item_cost * (self.supplier.commission_percentage / 100)) + self.supplier.commission_flat_rate)
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
    leema_label_from_url(self.postage_label)
  end

  def easypost_tracker
    EasyPost::Tracker.retrieve(self.tracking)
  end


end
