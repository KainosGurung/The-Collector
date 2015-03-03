class Patientprovider < ActiveRecord::Base
  belongs_to :patient#, :foreign_key => :patient_id
  belongs_to :provider#, :foreign_key => :provider_id

  validates_presence_of :patient,:message => 'does not exist'
  validates_presence_of :provider, :message => 'does not exist'
  validates_uniqueness_of :patient_id, :scope => [:provider_id], :message => 'has already been assigned to this provider'

end
