class Patient < ActiveRecord::Base
  has_many :patientproviders, dependent:  :destroy
  has_many :providers, through: :patientprovider

  has_many :patientbehaviors, dependent: :destroy
  has_many :behaviors, through: :patientbehavior
  has_many :incidents, dependent: :destroy


  validates :patient_name,
            presence: true,
            length: {minimum: 1, maximum: 15},
            format:  {:with => /\A[-a-zA-Z0-9\s]+\Z/}
  validates_uniqueness_of :patient_name, :case_sensitive => false

=begin ToDo this breaks the active/inactive setting
  validates :active,
            presence: true,
            :inclusion => {:in => [true, false]}
=end

end
