class Spree::Supplier < Spree::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessor :password, :password_confirmation

  #==========================================
  # Associations

  belongs_to :address, class_name: 'Spree::Address'
  accepts_nested_attributes_for :address

  if defined?(Ckeditor::Asset)
    has_many :ckeditor_pictures
    has_many :ckeditor_attachment_files
  end
  has_many   :products, through: :variants 
  has_many   :shipments, through: :stock_locations
  has_many   :stock_locations
  has_many   :supplier_variants
  has_many   :users, class_name: Spree.user_class.to_s
  has_many   :variants, through: :supplier_variants

  #==========================================
  # Validations
  
  has_attached_file :cover_photo, :styles => { :large => "1900"}, :default_url => "/assets/profile-placeholder.jpg"
  validates_attachment_content_type :cover_photo, :content_type => /\Aimage\/.*\Z/

  has_attached_file :store_logo, :styles => { :default => "80x80>"}, :default_url => "/assets/leema-seller-logo.jpg"
  validates_attachment_content_type :store_logo, :content_type => /\Aimage\/.*\Z/

  validates :commission_flat_rate,   presence: true
  validates :commission_percentage,  presence: true
  validates :email,                  presence: true, email: true, uniqueness: true
  validates :name,                   presence: true
  validates :url,                    format: { with: URI::regexp(%w(http https)), allow_blank: true }
  validates_presence_of :store_name

  #==========================================
  # Callbacks

  after_create :assign_user
  after_create :create_stock_location 
  after_create :send_welcome, if: -> { SpreeDropShip::Config[:send_supplier_email] }
  before_create :set_commission
  after_save :update_stock_location
  before_validation :check_url
  before_destroy :delete_stock_location

  #==========================================
  # Instance Methods
  scope :active, -> { where(active: true) }

  def deleted?
    deleted_at.present?
  end

  def user_ids_string
    user_ids.join(',')
  end

  def user_ids_string=(s)
    self.user_ids = s.to_s.split(',').map(&:strip)
  end

  def has_bank_account?
    true if self.bank_accounts
  end

  #==========================================
  # Protected Methods

  protected

    def assign_user
      if self.users.empty?
        if user = Spree.user_class.find_by_email(self.email)
          self.users << user
          self.save
        end
      end
    end

    def check_url
      unless self.url.blank? or self.url =~ URI::regexp(%w(http https))
        self.url = "http://#{self.url}"
      end
    end

    def create_stock_location
      if self.stock_locations.empty?
        location = self.stock_locations.build(
          active: true,
          address1: self.address.try(:address1),
          address2: self.address.try(:address2),
          city: self.address.try(:city),
          country_id: self.address.try(:country_id),
          name: self.name,
          state_id: self.address.try(:state_id),
          zipcode: self.address.try(:zipcode),
          phone: self.address.try(:phone)
        )
        # It's important location is always created.  Some apps add validations that shouldn't break this.
        location.save validate: false
      end
    end

    def update_stock_location
      if self.stock_locations.empty? == false
        location = self.stock_locations.first.update(
          address1: self.address.try(:address1),
          address2: self.address.try(:address2),
          city: self.address.try(:city),
          country_id: self.address.try(:country_id),
          name: self.name,
          state_id: self.address.try(:state_id),
          zipcode: self.address.try(:zipcode),
          phone: self.address.try(:phone)
        )
      end
    end

    def send_welcome
      begin
        Spree::SupplierMailer.welcome(self.id).deliver!
        # Specs raise error for not being able to set default_url_options[:host]
      rescue => ex #Errno::ECONNREFUSED => ex
        Rails.logger.error ex.message
        Rails.logger.error ex.backtrace.join("\n")
        return true # always return true so that failed email doesn't crash app.
      end
    end

    def set_commission
      unless changes.has_key?(:commission_flat_rate)
        self.commission_flat_rate = SpreeDropShip::Config[:default_commission_flat_rate]
      end
      unless changes.has_key?(:commission_percentage)
        self.commission_percentage = SpreeDropShip::Config[:default_commission_percentage]
      end
    end

end
