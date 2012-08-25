class HomeController < ApplicationController
  def index
  	respond_to do |format|
      format.html
      format.js
    end
  end

  def output
  	begin
	  	input_symbols = params[:symbols].split(" ")
	  	symbols = Securities::Stock.new(input_symbols)
			@history_data = symbols.history(:start_date => '2012-01-01', :end_date => '2012-03-01').results

		rescue Exception => exc
   		logger.error("Message for the log file #{exc.message}")
   		flash.now[:notice] = "#{exc.message}"
   	end

		respond_to do |format|
      format.html
      format.js
    end

  end
end