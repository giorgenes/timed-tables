module TimedTables
  class TimedTable < ActiveRecord::Base

    validates_presence_of :ncols
    attr_accessible :ncols

    def update_rows(jday, rows)
      rows.each do |row|
        if row.size != self.ncols + 1 then
          raise("invalid number of columns")
        end
        DayRowTotal.update_row(self, jday, row)
      end

      rows
    end

    def at(jday)
      result = {}
      DayRowTotal.find_all_in_jd(self.id, jday).each do |drt|
        result[drt.row_id] = drt.cols.to_a
      end

      result
    end

    def row_at(jday, row_id)
      if row = DayRowTotal.most_recent_previous_total(row_id, id, jday)
        row.cols
      end
    end

    def row_interval(rowid, b, e)
      DayRowTotal.find_between(b, e, rowid, self).map do |d| 
        [d.jday, d.cols.to_a]
      end
    end

    def clean(rowid)
      DayRowTotal.delete_all("row_id = #{rowid}")
    end
  end
end
