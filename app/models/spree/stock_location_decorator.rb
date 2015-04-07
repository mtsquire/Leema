Spree::StockLocation.class_eval do

  # callback to format phone number for shipments api
  # before_save :clean_phone_number

  # def clean_phone_number
  #   puts "cleaning phone number..."
  #   self.phone = self.phone.gsub(/[(),-. ]/,"")
  #   puts "cleaned! #{self.phone}"
  # end

end