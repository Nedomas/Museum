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
	  	periods = params[:periods].to_sym
			@history_data = Securities::Stock.new(:symbol => input_symbol, :start_date => start_date, :end_date => end_date, :periods => periods).output
      type = params[:type].to_sym
      variables = params[:variables].split(" ")
      unless type == :none
        indicator_data = Indicators::Data.new(@history_data).calc(:type => type, :params => variables)
        @indicator_output = indicator_data.output
        @indicator_abbr = indicator_data.abbr
        @indicator_params = indicator_data.params
        if type == :bb
          @indicator_name = ["middle band", "upper band", "lower band"]
        elsif type == :macd
          @indicator_name = ["macd line", "signal line", "macd histogram"]
        elsif type == :sto
          @indicator_name = ["fast %K", "slow %K", "full %D"]
        else 
          @indicator_name = type
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