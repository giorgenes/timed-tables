require 'spec_helper'

include TimedTables

describe DayRowTotal do
  describe ".new_and_each_since" do
    it "returns a new object on a posterior date" do
      tt = TimedTable.create(:ncols => 2)
      tt.update_rows(2456876, [[7, 15, 0], [57, 0, 15]])

      acs = []
      DayRowTotal.new_and_each_since(2456877, 7, tt.id) do |ac|
        acs << ac
      end

      acs.size.should == 1
      acs.first.new_record?.should be_true
    end
  end

  describe ".new_or_find_by_jd_and_account" do
    context 'with non existing record at the day' do
      context 'with an existing previous day' do
        it "returns a new record with a copy of the previous" do
          tt = TimedTable.create(:ncols => 2)
          tt.update_rows(2456876, [[7, 15, 0]])

          # safeguard
          DayRowTotal.count.should eq 1

          drt1 = DayRowTotal.last

          drt = DayRowTotal.new_or_find_by_jd_and_account(7, tt.id, 2456877)

          drt.new_record?.should be_true
          drt.jday.should eq 2456877
          drt.cols.should eq([15, 0])
        end
      end
    end
  end
end
