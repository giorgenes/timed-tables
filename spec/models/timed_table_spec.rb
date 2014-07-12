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
end
