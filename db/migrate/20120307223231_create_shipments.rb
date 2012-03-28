class CreateShipments < ActiveRecord::Migration
  def self.up
    create_table :shipments do |t|
      t.integer :sender_id
      t.string :sender_company_name
      t.string :sender_name
      t.string :sender_address
      t.string :sender_phone
      t.string :sender_email
      t.string :sender_city
      t.string :sender_state
      t.integer :sender_postal_code
      t.string :sender_country_code

      t.integer :receiver_id
      t.string :receiver_company_name
      t.string :receiver_name
      t.string :receiver_address
      t.string :receiver_phone
      t.string :receiver_email
      t.string :receiver_city
      t.string :receiver_state
      t.integer :receiver_postal_code
      t.string :receiver_country_code
      t.string :receiver_residential

      t.string  :provider
      t.string  :rate
      t.string  :status
      t.date    :shipment_date
      t.integer :package_count
      t.string  :fedex_service_type
      t.string  :fedex_package_types
      t.string  :fedex_dropoff_types

      t.decimal :total_net_charges
      t.decimal :total_surcharges
      t.string  :total_billing_weight
      t.decimal :total_taxes
      t.decimal :total_discounts
      t.decimal :base_charge

      t.integer :client_id
      t.integer :invoice_id
      t.timestamps
    end
  end

  def self.down
    drop_table :shipments
  end
end
