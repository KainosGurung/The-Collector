class CreateBehaviors < ActiveRecord::Migration
  def change
    create_table :behaviors do |t|
      t.string :behavior_name
      t.string :behavior_description
      t.boolean :active
    end
  end
end
