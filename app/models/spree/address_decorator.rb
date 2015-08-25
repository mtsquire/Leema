Spree::Address.class_eval do
  validates :phone, length: { minimum: 10, maximum: 10 }, numericality: true, presence: true
end