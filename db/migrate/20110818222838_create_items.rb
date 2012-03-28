class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :shipment_id
      t.integer :invoice_id
      t.string  :weight_units
      t.integer   :weight_value
      t.string :dimension_units
      t.integer :length
      t.integer :width
      t.integer :height

      t.integer :quantity
      t.string :description
      t.string :amount

      t.string :packaging_type
      t.string :dropoff_type
      t.string :service_type


      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
