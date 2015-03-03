class Patientbehavior < ActiveRecord::Base
  belongs_to :patient#, :foreign_key => :patient_id
  belongs_to :behavior#, :foreign_key => :provider_id

  validates_presence_of :patient,:message => 'does not exist'
  validates_presence_of :behavior, :message => 'does not exist'
  validates_uniqueness_of :behavior_id, :scope => [:patient_id], :message => 'is already being tracked for this individual'

end
