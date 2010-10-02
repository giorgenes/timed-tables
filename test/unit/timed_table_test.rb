require 'test_helper'

class TimedTableTest < ActiveSupport::TestCase
	test "table basics" do
		tt = TimedTable.create(:ncols => 3)
		
		tt.update_rows(10, [[0, 100, 200, 300]])
		table = tt.at(10)
		assert_equal({ 0 => [100, 200, 300]}, table)

		tt.update_rows(9, [[0, 100, 200, 300]])
		table = tt.at(10)
		assert_equal({ 0 => [200, 400, 600]}, table)

		rows = tt.row_interval(0, 0, 100)
		assert_equal([[100, 200, 300], [200, 400, 600]], rows)
	end
end
