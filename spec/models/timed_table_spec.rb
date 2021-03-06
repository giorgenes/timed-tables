require 'spec_helper'

include TimedTables

describe TimedTable do
	it "table basics" do
		tt = TimedTable.create(:ncols => 3)
		
		tt.update_rows(10, [[0, 100, 200, 300]])
		table = tt.at(10)
		table.should eq({ 0 => [100, 200, 300]})

		tt.update_rows(9, [[0, 100, 200, 300]])
		table = tt.at(10)
		table.should eq({ 0 => [200, 400, 600]})

		rows = tt.row_interval(0, 0, 100)
		rows.should eq([[9, [100, 200, 300]], [10, [200, 400, 600]]])
	end

  it "updates rows on day by day" do
		tt = TimedTable.create(:ncols => 2)

    tt.update_rows(2456876, [[7, 15, 0]])
    tt.update_rows(2456877, [[7, 0, 15]])

    rows = tt.row_interval(7, 2456876, 2456878)

    rows.should eq([[2456876, [15, 0]], [2456877, [15, 15]]])
  end


  it "bug" do
		tt = TimedTable.create(:ncols => 2)

    TimedTables::DayRowTotal.update_row(tt, 2456876, [7, 150, 0])
    TimedTables::DayRowTotal.update_row(tt, 2456877, [7, 0, 100])
    TimedTables::DayRowTotal.update_row(tt, 2456882, [7, 0, 200])

    dwt = TimedTables::DayRowTotal.where(row_id: 7, timed_table_id: tt.id, jday: 2456882).first

    dwt.cols.should == [150, 300]
  end
end
