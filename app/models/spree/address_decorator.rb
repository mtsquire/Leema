Spree::Address.class_eval do
  validates_length_of :phone, :minimum => 10
end