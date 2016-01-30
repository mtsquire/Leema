Spree::StockLocation.class_eval do
  geocoded_by :address
  after_validation :geocode, if: ->(stock_location){ stock_location.address1.present? and stock_location.address1_changed? }

  def address
    [address1, city, state_text, country.try(:iso)].compact.join(', ')
  end
end