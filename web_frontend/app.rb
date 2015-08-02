require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require 'polylines'
require_relative 'service'

class PbrApp < Sinatra::Base

	set :run, true
	set :server, 'webrick'
	
  get '/' do
  	erb :index
  end

  post '/route' do
  	@waypoints = get_waypoints(params)
  	erb :map
  end

	run! if app_file == $0
end