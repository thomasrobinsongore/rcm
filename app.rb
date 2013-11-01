require 'sinatra'
require "sinatra/json"

get '/' do
  erb :index
end

get '/list.json' do
  options = {
    search: params[:search],
    column: params[:iSortCol_0],
    direction: params[:sSortDir_0]
  }

  data = Languages.new(options).filter

  json({
    aaData: data,
    sEcho: params[:sEcho],
    iTotalRecords: Languages::DATA.length,
    iTotalDisplayRecords: data.length
  })
end

class Languages
  DATA = [
    ['Kieser', 'GlobalTxt', 'USA', 'ATT', 'USD', '0.01'],
    ['Kieser', 'GlobalTxt', 'France', 'Verizon', 'USD', '0.02'],
    ['CLX', 'GlobalTxt', 'USA', 'ATT', 'EUR', '0.011'],
    ['Infobip', 'GlobalTxt', 'Spain', 'ATT', 'AUD', '0.023'],
    ['Nokia', 'GlobalTxt', 'UK', 'O2', 'GBP', '0.03'],
    ['Kieser', 'GlobalTxt', 'Germany', 'ATT', 'USD', '0.034'],
    ['CLX', 'GlobalTxt', 'UK', 'Vodafone', 'GBP', '0.04'],
    ['Nokia', 'GlobalTxt', 'Germany', 'Vodafone', 'USD', '0.01'],
    ['CLX', 'GlobalTxt', 'USA', 'ATT', 'AUD', '0.01'],
    ['Kieser', 'GlobalTxt', 'UK', 'Verizon', 'AUD', '0.054'],
    ['CLX', 'GlobalTxt', 'USA', 'Vodafone', 'EUR', '0.0111'],
    ['Infobip', 'GlobalTxt', 'Spain', 'O2', 'AUD', '0.027'],
    ['Nokia', 'GlobalTxt', 'USA', 'O2', 'GBP', '0.033'],
    ['Kieser', 'GlobalTxt', 'Germany', 'Verizon', 'EUR', '0.0398'],
    ['CLX', 'GlobalTxt', 'UK', 'Vodafone', 'GBP', '0.047'],
    ['Nokia', 'GlobalTxt', 'France', 'O2', 'GBP', '0.32']
  ]

  COLUMNS = { 'Client' => 0, 'Product' => 1, 'Destination' => 2, 'Carrier' => 3, 'Currency' => 4 }

  def initialize(options)
    @search    = options[:search] || {}
    @column    = options[:column].to_i
    @direction = options[:direction] == 'asc' ? 1 : -1
  end

  def filter
    filtered = DATA.select { |l| match?(l) }
    filtered.sort { |l1, l2| compare(l1, l2) }
  end

  private

  def match?(language)
    @search.each do |name, options|
      value = language[COLUMNS[name]]
      return false unless options.include?(value)
    end

    true
  end

  def compare(language1, language2)
    column1 = language1[@column]
    column2 = language2[@column]

    (column1 <=> column2) * @direction
  end
end
