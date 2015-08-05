def get_waypoints address1, address2

	origin      = get_coordinates address1
	destination = get_coordinates address2

	route_geometry = get_route_geometry origin, destination

	decode_polyline route_geometry
end

def get_coordinates address
	JSON.parse(get_url "http://pelias.mapzen.com/search?input=#{address}")['features'].first['geometry']['coordinates']
end

def get_route_geometry origin, destination
	# currently using mapzen's free osrm endpoint; point this to ours when we have it up
	JSON.parse(get_url "http://osrm.mapzen.com/foot/viaroute?loc=#{origin.last},#{origin.first}&loc=#{destination.last},#{destination.first}&instructions=true")['route_geometry']
end

def get_url string
	Net::HTTP.get(URI.parse(URI.encode(string)))
end

def decode_polyline polyline
	# why the frick do i need to divide by 10 lol
	# decoded directions have lat/long off by factor of 10
	# either mapzen's osrm is buggy or this polylines library is buggy
	Polylines::Decoder.decode_polyline(polyline).map do |point|
		point.map do |val|
			val / 10
		end
	end
end
