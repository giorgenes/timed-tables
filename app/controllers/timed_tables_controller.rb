class TimedTablesController < ApplicationController
	def create
		@timed_table = TimedTable.create(params[:timed_table])

		respond_to do |format|
			format.xml { render :xml => @timed_table }
		end
	end

	def show
		@timed_table = TimedTable.find(params[:id])

		respond_to do |format|
			format.xml { render :xml => @timed_table }
		end
	end

	def create_row
		@timed_table = TimedTable.find(params[:id])
		@timed_table.create_row(params[:rowid])

		respond_to do |format|
			format.xml { head :ok }
		end
	end
end

