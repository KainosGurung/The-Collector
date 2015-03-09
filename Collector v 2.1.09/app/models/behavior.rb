class Behavior < ActiveRecord::Base
  has_many :patientbehaviors, dependent: :destroy
  has_many :patients, through: :patientbehavior
  has_many :incidents, dependent: :destroy

  before_validation :capitalize

  validates :behavior_name,
            uniqueness: true,
            presence: true,
            length: {minimum: 1, maximum: 15}

  validates :behavior_description,
            presence: true,
            length: {minimum: 1, maximum: 254}

=begin ToDo this breaks the active/inactive setting
  validates :active,
            presence: true,
            :inclusion => {:in => [true, false]}
=end


  def capitalize
    self.behavior_name = self.behavior_name.capitalize if self.behavior_name.present?
  end
end
