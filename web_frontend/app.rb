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

  get '/geocode' do
    return get_coordinates params['address']
  end

  get '/geometry' do
    return get_route_geometry params['origin'], params['destination']
  end

  get '/decode_polyline' do
    return decode_polyline params['polyline']
  end

	run! if app_file == $0
end