ENV['RACK_ENV'] = 'test'

require_relative '../application'
require 'rspec'
require 'rack/test'

describe 'The FpTest Application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'says hello' do
    get '/'
    expect(last_response).to be_ok
  end
end