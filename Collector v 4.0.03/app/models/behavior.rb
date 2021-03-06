class Behavior < ActiveRecord::Base
  has_many :patientbehaviors, dependent: :destroy
  has_many :patients, through: :patientbehavior
  has_many :incidents, dependent: :destroy

  validates :behavior_name,
            length: {minimum: 1, maximum: 25},
            format:  {:with => /\A[-a-zA-Z0-9\s]+\Z/}

  validates :behavior_description,
            length: {minimum: 1, maximum: 254}

  validates_uniqueness_of :behavior_name, :case_sensitive => false

=begin ToDo this breaks the active/inactive setting
  validates :active,
            presence: true,
            :inclusion => {:in => [true, false]}
=end

end
