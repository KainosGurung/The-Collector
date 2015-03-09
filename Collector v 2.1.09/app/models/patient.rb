class Patient < ActiveRecord::Base
  has_many :patientproviders, dependent:  :destroy
  has_many :providers, through: :patientprovider

  has_many :patientbehaviors, dependent: :destroy
  has_many :behaviors, through: :patientbehavior
  has_many :incidents, dependent: :destroy


  before_validation :capitalize

  validates :patient_name,
            uniqueness: true,
            presence: true,
            length: {minimum: 1, maximum: 15}
=begin ToDo this breaks the active/inactive setting
  validates :active,
            presence: true,
            :inclusion => {:in => [true, false]}
=end

  def capitalize
    self.patient_name = self.patient_name.capitalize if self.patient_name.present?
  end
end
