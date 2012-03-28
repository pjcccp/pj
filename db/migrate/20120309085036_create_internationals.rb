class CreateInternationals < ActiveRecord::Migration
  def self.up
    create_table :internationals do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :internationals
  end
end
