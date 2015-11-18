# A rule to limit a promotion based on having only one product in the order.
module Spree
  class Promotion
    module Rules
      class OneProduct < PromotionRule
        has_and_belongs_to_many :products, class_name: '::Spree::Product', join_table: 'spree_products_promotion_rules', foreign_key: 'promotion_rule_id'

        MATCH_POLICIES = %w(any all none)
        preference :match_policy, :string, default: MATCH_POLICIES.first

        # scope/association that is used to test eligibility
        def eligible_products
          products
        end

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          if eligible_products.count == 1
            return true
          else
            return false
          end
        end

        def product_ids_string
          product_ids.join(',')
        end

        def product_ids_string=(s)
          self.product_ids = s.to_s.split(',').map(&:strip)
        end
      end
    end
  end
end