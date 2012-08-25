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
	  	start_date = params[:start_date]
	  	end_date = params[:end_date]
	  	symbols = Securities::Stock.new(input_symbols)
			@history_data = symbols.history(:start_date => start_date, :end_date => end_date).results

		rescue Exception => exc
   		flash.now[:notice] = "#{exc.message}"
   	end

		respond_to do |format|
      format.html
      format.js
    end

  end
end