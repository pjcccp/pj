class CreateDomestics < ActiveRecord::Migration
  def self.up
    create_table :domestics do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :domestics
  end
end
