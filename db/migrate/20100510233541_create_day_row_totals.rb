class CreateDayRowTotals < ActiveRecord::Migration
  def self.up
    create_table :day_row_totals do |t|
      t.integer :timed_table_id
      t.integer :row_id
      t.integer :jday
      t.string :cols

      t.timestamps
    end
  end

  def self.down
    drop_table :day_row_totals
  end
end
