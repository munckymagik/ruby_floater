require 'sinatra'
require_relative 'fp_errors'

get '/' do
  @results = FpRoundingErrors.run_tests
  erb :index
end