class CreateTimedTables < ActiveRecord::Migration
  def self.up
    create_table :timed_tables do |t|
      t.integer :ncols
      t.timestamps
    end
  end

  def self.down
    drop_table :timed_tables
  end
end
