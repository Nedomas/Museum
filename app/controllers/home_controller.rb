class HomeController < ApplicationController
  def index
  	respond_to do |format|
      format.html
      format.js
    end
  end

  def output
  	begin
	  	input_symbol = params[:symbol]
      @symbol = input_symbol
	  	start_date = params[:start_date]
	  	end_date = params[:end_date]
	  	type = params[:type].to_sym
			@history_data = Securities::Stock.new(:symbol => input_symbol, :start_date => start_date, :end_date => end_date, :type => type).output
      indicator = params[:indicator].to_sym
      variables = params[:variables].split(" ")
      @lookup = Securities::Lookup.new(input_symbol).output[0]
      unless indicator == :none
        indicator_data = Indicators::Data.new(@history_data).calc(:type => indicator, :params => variables)
        @indicator_output = indicator_data.output
        @indicator_abbr = indicator_data.abbr
        @indicator_params = indicator_data.params
        if indicator == :bb
          @indicator_name = ["middle band", "upper band", "lower band"]
        elsif indicator == :macd
          @indicator_name = ["macd line", "signal line", "macd histogram"]
        elsif indicator == :sto
          @indicator_name = ["fast %K", "slow %K", "full %D"]
        else 
          @indicator_name = indicator
        end
      end

		rescue Exception => exc
   		flash.now[:error] = "#{exc.message}"
   	end

    # If symbol doesn't exist or returned no results from securities.

		respond_to do |format|
      format.html
      format.js
    end

  end
end