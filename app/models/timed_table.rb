class TimedTable < ActiveRecord::Base
	validates_presence_of :ncols

	def update_rows(jday, rows)
		rows.each do |row|
			if row.size != self.ncols + 1 then
				raise("invalid number of columns")
			end
			DayRowTotal.update_row(self, jday, row)
		end
	end

	def at(jday)
		result = {}
		DayRowTotal.find_all_in_jd(self.id, jday).each do |drt|
			result[drt.row_id] = drt.cols.to_a
		end

		result
	end
end
