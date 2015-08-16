require 'mechanize'
require 'net/http'
require 'uri'
require 'json'

def geocode address
	chicago_bbox = "-87.397217, 42.07436, -87.968437, 41.624851"
	pelias_response = JSON.parse(Net::HTTP.get(URI.parse(URI.encode("http://pelias.mapzen.com/search?input=#{address}&bbox=#{chicago_bbox}"))))
	pelias_response['features'].first['geometry']['coordinates']
end

def scrape_street_closure_report outfile
	agent = Mechanize.new
	page = agent.get("https://webapps1.cityofchicago.org/StreetClosure/org/cityofchicago/streetclosure/cdot/getreport.do")
	last_row = page.search("/html/body/div[@id='mainContent']/div[@id='content']/div[@id='container']/div[@class='header']/div[@id='content-container']/center[1]/div[@id='content-panel']/center[2]/table[@class='resultTable']//tr").count
	result_table = page.search("/html/body/div[@id='mainContent']/div[@id='content']/div[@id='container']/div[@class='header']/div[@id='content-container']/center[1]/div[@id='content-panel']/center[2]/table[@class='resultTable']")
	first_row = 2

	first_row.upto last_row do |row|

		from_number   = result_table.at(".//tr[#{row}]/td[1]").text.chomp # 123
		to_number     = result_table.at(".//tr[#{row}]/td[2]").text.chomp # 456
		direction     = result_table.at(".//tr[#{row}]/td[3]").text.chomp # n
		street_name   = result_table.at(".//tr[#{row}]/td[4]").text.chomp # dearborn
		street_suffix = result_table.at(".//tr[#{row}]/td[5]").text.chomp # st
		street        = "#{direction} #{street_name} #{street_suffix}"
		from_address  = "#{from_number} #{street}"
		to_address    = "#{to_number} #{street}"
		# start_date    = result_table.at(".//tr[#{row}]/td[6]").text.chomp
		# end_date      = result_table.at(".//tr[#{row}]/td[7]").text.chomp

		lil_more_than_one_third = 0.334

		sleep lil_more_than_one_third # get around rate limiting; max 3 queries per second
		starting_coords = geocode from_address
		sleep lil_more_than_one_third # let's host our own pelias!
		ending_coords   = geocode to_address

		File.open(outfile, 'a+') do |file|
			file.puts "#{from_address} to #{to_address}"
			file.puts "#{starting_coords},#{ending_coords}"
		 	file.puts
		end
	end
end