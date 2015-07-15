Spree::Supplier.class_eval do

  attr_accessor :first_name, :last_name, :merchant_type

  has_many :bank_accounts, class_name: 'Spree::SupplierBankAccount'

  validates :tax_id, length: { is: 9, allow_blank: true }

  before_create :assign_name
  before_create :stripe_recipient_setup
  after_update :stripe_recipient_update 
  after_save :update_display_name_to_store_name

  private

  def update_display_name_to_store_name
    puts "updating display name with store name: #{self.store_name}"
    self.users.first.update_attribute(:display_name, self.store_name.downcase.gsub(" ","-").gsub("'",""))
    puts "new display name = #{self.users.first.display_name}"
  end

  def assign_name
    self.address = Spree::Address.default     unless self.address.present?
    self.address.first_name = self.first_name unless self.address.first_name.present?
    self.address.last_name = self.last_name   unless self.address.last_name.present?
  end

  def stripe_recipient_setup
    return if self.tax_id.blank? and self.address.blank?

    recipient = Stripe::Recipient.create(
      :name => (self.merchant_type == 'business' ? self.name : "#{self.address.first_name} #{self.address.last_name}"),
      :type => (self.merchant_type == 'business' ? 'corporation' : "individual"),
      :email => self.email,
      :bank_account => self.bank_accounts.first.try(:token)
    )

    if new_record?
      self.token = recipient.id
    else
      self.update_column :token, recipient.id
    end
  end

  def stripe_recipient_update
    unless new_record? or !changed?
      if token.present?
        rp = Stripe::Recipient.retrieve(token)
        rp.name  = name
        rp.email = email
        if tax_id.present?
          rp.tax_id = tax_id
        end
        rp.bank_account = bank_accounts.first.token if bank_accounts.first && bank_accounts.first.changed?
        rp.save
      else
        stripe_recipient_setup
      end
    end
  end

end
