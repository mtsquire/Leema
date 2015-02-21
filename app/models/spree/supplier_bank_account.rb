module Spree
  class SupplierBankAccount < ActiveRecord::Base

    attr_accessor :account_number, :routing_number, :country

    belongs_to :supplier

    validates :country,    presence: true
    validates :masked_number,  presence: true
    validates :name,           presence: true
    validates :supplier,       presence: true
    validates :token,          presence: true, uniqueness: true

    after_create :stripe_recipient_update

    def stripe_recipient_update
      @supplier = self.supplier
      unless new_record? or !changed?
        if token.present?
          puts "Starting stripe recipient update"
          rp = Stripe::Recipient.retrieve(@supplier.token)
          rp.bank_account = token
          puts "recipient bank account = #{rp.bank_account}"
          rp.save
        else
          stripe_recipient_setup
        end
      end
    end

  end
end