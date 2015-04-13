class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :provider_name
      t.string :password_salt
      t.string :password_hash
      t.boolean :admin
      t.boolean :active
    end
  end
end
