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
	  	periods = params[:periods].to_sym
	  	symbols = Securities::Stock.new(input_symbols)
			@history_data = symbols.history(:start_date => start_date, :end_date => end_date, :periods => periods).results

		rescue Exception => exc
   		flash.now[:error] = "#{exc.message}"
   	end

    # If symbol doesn't exist or returned no results from securities.
    empty_symbols = []
    @history_data.each { |symbol, value| empty_symbols << symbol if value.empty? }
    flash.now[:warning] = "There were no results for #{empty_symbols.join(", ")}." unless empty_symbols.empty?

		respond_to do |format|
      format.html
      format.js
    end

  end
end