Spree::Variant.class_eval do
  after_create :remove_tracking, :unless => :is_master?
  # def false
  #   false
  # end

  def remove_tracking
    # Remove the tracking requirement on new variants.
    puts "variant is master? #{self.is_master?}"
    self.track_inventory = false
    puts "variant is tracking inventory? #{self.track_inventory}"
  end
end