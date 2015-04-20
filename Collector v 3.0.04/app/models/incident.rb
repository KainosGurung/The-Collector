class Incident < ActiveRecord::Base
  belongs_to :patient
  belongs_to :provider
  belongs_to :behavior

  validates_presence_of :patient, :message => 'does not exist'
  validates_presence_of :provider, :message => 'does not exist'
  validates_presence_of :behavior, :message => 'does not exist'

end

