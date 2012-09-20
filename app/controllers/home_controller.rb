class HomeController < ApplicationController
  def index
  	respond_to do |format|
      format.html
      format.js
    end
  end

  def output
  	input_symbol = params[:symbol]
  	start_date = params[:start_date]
  	end_date = params[:end_date]
  	type = params[:type].to_sym
    indicator = params[:indicator].to_sym
    variables = params[:variables].split(" ")
    @query = Array.new
    begin
      begin
  		  @history_data = Securities::Stock.new(:symbol => input_symbol, :start_date => start_date, :end_date => end_date, :type => type).output
        @query << "history_data = Securities::Stock.new(:symbol => '#{input_symbol}', :start_date => '#{start_date}', :end_date => '#{end_date}', :type => :#{type}).output"
        @symbol = input_symbol
        @lookup = Securities::Lookup.new(@symbol).output[0]
        @query << "Securities::Lookup.new('#{@symbol}').output[0]"
      rescue Exception => exc
        if exc.message == 'Stock symbol does not exist.'
          @lookup = Securities::Lookup.new(input_symbol).output[0]
          @symbol = @lookup[:symbol]
          @query << "lookup = Securities::Lookup.new('#{@symbol}').output[0]"
          @history_data = Securities::Stock.new(:symbol => @symbol, :start_date => start_date, :end_date => end_date, :type => type).output
          flash.now[:warning] = "'#{input_symbol}' does not exist. Did you mean #{@symbol}?"
          @query << "history_data = Securities::Stock.new(:symbol => '#{@symbol}', :start_date => '#{start_date}', :end_date => '#{end_date}', :type => :#{type}).output"
        end
      end
      unless indicator == :none
        indicator_data = Indicators::Data.new(@history_data).calc(:type => indicator, :params => variables)
        @query << "Indicators::Data.new(history_data).calc(:type => :#{indicator}, :params => #{variables})"
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
      if exc.message == 'There were no results for this lookup.'
        flash.now[:error] = "Stock symbol does not exist and a query for similar symbols returned nothing."
      elsif exc.message == 'Stock symbol does not exist.'
        flash.now[:error] = "Yahoo Finance does not provide history data for this symbol."
      else
        flash.now[:error] = "#{exc.message}"
      end
    end

    # If symbol doesn't exist or returned no results from securities.

		respond_to do |format|
      format.html
      format.js
    end

  end
end