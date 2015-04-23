class Provider < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password
  has_many :patientproviders, dependent: :destroy
  has_many :patients, through: :patientproviders
  has_many :incidents, dependent: :destroy

 # before_validation :capitalize
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create

  #TODO: DB field constraints
  validates :provider_name,
            presence: true,
            length: {minimum: 1, maximum: 15},
            format:  {:with => /\A[-a-zA-Z0-9\s]+\Z/}

  validates_uniqueness_of :provider_name, :case_sensitive => false

=begin ToDo this breaks the active/inactive setting
  validates :active,
            presence: true,
            :inclusion => {:in => [true, false]}
=end
  def self.authenticate(provider_name, password)
    provider = Provider.where(provider_name: provider_name).first
    if provider && provider.password_hash == BCrypt::Engine.hash_secret(password, provider.password_salt) && provider.active == TRUE
        provider
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, self.password_salt)
    end
  end

end