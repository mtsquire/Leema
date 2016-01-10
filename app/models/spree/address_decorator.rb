Spree::Address.class_eval do
  geocoded_by :address
  after_validation :geocode, if: ->(address){ address.address1.present? and address.address1_changed? }

  def address
    [address1, city, state_text, country.try(:iso)].compact.join(', ')
  end

end