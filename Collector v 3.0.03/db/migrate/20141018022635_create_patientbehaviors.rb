class CreatePatientbehaviors < ActiveRecord::Migration
  def change
    create_table :patientbehaviors do |t|
      t.belongs_to :patient
      t.belongs_to :behavior
    end
  end
end
