def get_waypoints params

	origin_coords      = geocode params['origin']
	destination_coords = geocode params['destination']

	directions = get_directions origin_coords, destination_coords

	# why the frick do i need to divide by 10 lol
	# decoded directions have lat/long off by factor of 10
	# either mapzen's osrm is buggy or this polylines library is buggy
	Polylines::Decoder.decode_polyline(directions['route_geometry']).map do |point|
		point.map do |val|
			val / 10
		end
	end
end

def geocode address
	JSON.parse(get_url "http://pelias.mapzen.com/search?input=#{address}")['features'].first['geometry']['coordinates']
end

def get_directions origin, destination
	# currently using mapzen's free osrm endpoint; point this to ours when we have it up
	JSON.parse(get_url "http://osrm.mapzen.com/foot/viaroute?loc=#{origin.last},#{origin.first}&loc=#{destination.last},#{destination.first}&instructions=true")
end

def get_url string
	Net::HTTP.get(URI.parse(URI.encode(string)))
end
