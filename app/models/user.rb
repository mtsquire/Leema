class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         # For facebook authentication
         :omniauthable, :omniauth_providers => [:facebook]

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_attached_file :avatar, :styles => { :medium => "200x200>", :thumb => "80x80>", :mini => "20x20>" }, :default_url => "noimage-small.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_attachment_size :avatar, :less_than => 1.megabytes

  # callbacks
  before_create :create_display_name
  after_save :create_admin

  #class methods

  def to_param
    display_name
  end

  def create_display_name
    puts "creating display name!"
    self.display_name = full_name.downcase.gsub(" ","") + SecureRandom.hex(3)
  end

  def full_name
    first_name + " " + last_name
  end

  def leema_admin?
    if email == "brandon.a.hay@gmail.com"
      true
    elsif email == "mtsquire@gmail.com"
      true
    elsif email == "scottlevy89@gmail.com"
      true
    else
      false
    end
  end

  # FB authentication
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def create_admin
    spree_roles << Spree::Role.find_or_create_by(name: "admin")
  end

end
