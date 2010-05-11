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

	def update_rows
		@timed_table = TimedTable.find(params[:id])
		@timed_table.update_rows(params[:jday], params[:rows])

		respond_to do |format|
			format.xml { head :ok }
		end
	end

	def at
		@timed_table = TimedTable.find(params[:id])
		table = @timed_table.at(params[:jday])
		
		respond_to do |format|
			format.xml { render :xml => table }
		end

	end
end

