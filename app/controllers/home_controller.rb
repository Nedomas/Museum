class HomeController < ApplicationController
  def index
  	
  end

  def output
  	input_symbols = params[:symbols].split(" ")
  	symbols = Securities::Stock.new(input_symbols)
		@history_data = symbols.history(:start_date => '2012-01-01', :end_date => '2012-03-01').results
  end
end
