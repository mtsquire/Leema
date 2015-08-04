Spree::PromotionHandler::Coupon.class_eval do  

  private
  
  def ineligible_for_this_order
    if !promotion.promotion_rules.empty?
      promotion.promotion_rules.each do |i|
        if i.type = "Spree::Promotion::Rules::UserLoggedIn"
          self.error = "You must sign in or sign up to redeem this promotion."
        else
          self.error = Spree.t(:coupon_code_not_eligible)
        end
      end
    end
  end

end