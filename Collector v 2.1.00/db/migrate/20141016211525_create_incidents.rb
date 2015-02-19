class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.belongs_to :provider
      t.belongs_to :patient
      t.belongs_to :behavior
      t.timestamps
    end
  end
end
