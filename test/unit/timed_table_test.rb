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
	end
end
