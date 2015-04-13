class CreatePatientproviders < ActiveRecord::Migration
  def change
    create_table :patientproviders do |t|
      t.belongs_to :provider
      t.belongs_to :patient
    end
  end
end
