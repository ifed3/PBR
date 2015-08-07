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

  get '/route' do
  	@waypoints = get_waypoints(params['origin'], params['destination'])
  	erb :map
  end

  get '/polyline_for' do
    get_waypoints(params['origin'], params['destination']).inspect
  end

	run! if app_file == $0
end