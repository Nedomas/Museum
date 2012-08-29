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
      type = params[:type].to_sym
      variables = params[:variables].split(" ")
      unless type == :none
        @indicator_data = Ta::Data.new(@history_data).calc(:type => type, :variables => variables)
        if type == :bb
          @indicator_name = ["middle band", "upper band", "lower band"]
        else 
          @indicator_name = type
        end
      end

		rescue Exception => exc
   		flash.now[:error] = "#{exc.message}"
    else
      empty_symbols = []
      @history_data.each { |symbol, value| empty_symbols << symbol if value.empty?
        flash.now[:warning] = "There were no results for #{empty_symbols.join(", ")}." unless empty_symbols.empty?
      }
   	end

    # If symbol doesn't exist or returned no results from securities.

		respond_to do |format|
      format.html
      format.js
    end

  end
end