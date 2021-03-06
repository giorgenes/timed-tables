module TimedTables
  # Stores the total of an Account in a given day.
  class DayRowTotal < ActiveRecord::Base
    belongs_to :timed_table
    serialize :cols, Array
    validates_presence_of %w(timed_table_id jday row_id)
    attr_accessible :row_id, :timed_table_id, :jday

    # Find all DayRowTotal's of a timeline in a given jd
    # If there is no DayRowTotal in that day but in an older day,
    # the older DayRowTotal is cloned and the jd set to the
    # requested day.
    def self.find_all_in_jd(timed_table_id, jd)
      ats = DayRowTotal.find_by_sql("select * from day_row_totals as A1 where jday <= #{jd} and jday > 0 and timed_table_id = #{timed_table_id} and jday = (select max(jday) from day_row_totals as A2 where A1.row_id = A2.row_id and jday <= #{jd} and jday > 0 and timed_table_id = #{timed_table_id})"
      )

      ats.collect do |at|
        if at.jday == jd then
          at
        else
          nat = at.clone
          nat.jday = jd
          nat
        end
      end
    end

    def self.most_recent_previous_total(row_id, timed_table_id, jd)
      scope = DayRowTotal.where(row_id: row_id, timed_table_id: timed_table_id)
      if max = scope.where("jday <= ?", jd).maximum(:jday)
        scope.where(jday: max).first
      end
    end

    # Finds an DayRowTotal by (Account, Timeline, jd).
    # If there is none, an older one is cloned and the jday is updated.
    def self.new_or_find_by_jd_and_account(row_id, timed_table_id, jd)
      at = most_recent_previous_total(row_id, timed_table_id, jd)
      if at.nil? then
        at = DayRowTotal.new(:row_id => row_id, :timed_table_id => timed_table_id, :jday => jd)
      end

      if at.jday != jd
        at = at.dup
        at.jday = jd
      end

      at
    end

    # Find DayRowTotals by Account between the days s and e
    def self.find_between(s, e, acc_id, timeline)
      DayRowTotal.find(:all,
          :conditions => 
            [
            "row_id = ? " + 
            "and jday >= ? " + "
            and jday < ? and timed_table_id = ?", 
              acc_id, s, e, timeline.id],
          :order => "jday")
    end

    # Finds all DayRowTotal's with row_id and jd >= jday
    def self.all_since(jday, row_id, timed_table_id)
      DayRowTotal.find(:all, :conditions => 
        ["row_id = ? and jday >= ? and timed_table_id = ?", 
          row_id, jday, timed_table_id],
        :order => "jday ASC")
    end

    # Iterates through each DayRowTotal with row_id and jd >= jday.
    # If there is no DayRowTotal exactly at jday, a new one is created
    # based on an older one.
    def self.new_and_each_since(jday, row_id, timed_table_id, &blk)
      ats = DayRowTotal.all_since(jday, row_id, timed_table_id)
      if ats.size > 0 then
        if ats[0].jday != jday then
          at = DayRowTotal.new_or_find_by_jd_and_account(row_id, timed_table_id, jday)
          yield at
        end
        
        ats.each do |at|
          yield at
        end
      else
        at = DayRowTotal.new_or_find_by_jd_and_account(row_id, timed_table_id, jday)
        yield at
      end
    end

    # Creates or updates DayRowTotal objects given a Record in a jday
    # mod can be > 0 (to add the record) or < 0 (to remove the record)
    def self.update_row(timed_table, jday, row)
      rowid = row[0]
      row = row[1, row.size]
      DayRowTotal.new_and_each_since(jday, rowid, timed_table.id) do |ac|
        if ac.cols.nil? or ac.cols.empty?
          ac.cols = Array.new(timed_table.ncols, 0)
        end
        ac.cols.each_with_index do |e, index|
          ac.cols[index] += row[index]
        end
        ac.save
      end
    end

  end
end
