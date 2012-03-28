class CreateFreights < ActiveRecord::Migration
  def self.up
    create_table :freights do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :freights
  end
end
