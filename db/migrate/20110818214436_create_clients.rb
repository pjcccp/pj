class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :email
      t.string :city
      t.string :state
      t.integer :postal_code
      t.string :country_code
      t.integer :user_type
      t.integer :user

      t.integer :fedex_account_number
      t.string  :fedex_key
      t.string  :fedex_password
      t.integer :fedex_meter_number

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
