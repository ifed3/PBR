require 'mechanize'
require 'net/http'
require 'uri'
require 'json'

def geocode address
	chicago_bbox = "-87.397217, 42.07436, -87.968437, 41.624851"
	JSON.parse(Net::HTTP.get(URI.parse(URI.encode("http://pelias.mapzen.com/search?input=#{address}&bbox=#{chicago_bbox}"))))['features'].first['geometry']['coordinates']
end

def scrape_street_closure_report outfile
	agent = Mechanize.new
	page = agent.get("https://webapps1.cityofchicago.org/StreetClosure/org/cityofchicago/streetclosure/cdot/getreport.do")
	first_row = 2
	last_row = page.search("/html/body/div[@id='mainContent']/div[@id='content']/div[@id='container']/div[@class='header']/div[@id='content-container']/center[1]/div[@id='content-panel']/center[2]/table[@class='resultTable']//tr").count
	result_table = page.search("/html/body/div[@id='mainContent']/div[@id='content']/div[@id='container']/div[@class='header']/div[@id='content-container']/center[1]/div[@id='content-panel']/center[2]/table[@class='resultTable']")

	output_json = {}
	output_json[:executionTime] = Time.now.inspect

	closures = []

	first_row.upto last_row do |row|

		closure = {}
		from_number   = result_table.at(".//tr[#{row}]/td[1]").text.chomp # 123
		to_number     = result_table.at(".//tr[#{row}]/td[2]").text.chomp # 456
		direction     = result_table.at(".//tr[#{row}]/td[3]").text.chomp # n
		street_name   = result_table.at(".//tr[#{row}]/td[4]").text.chomp # dearborn
		street_suffix = result_table.at(".//tr[#{row}]/td[5]").text.chomp # st
		street        = "#{direction} #{street_name} #{street_suffix}"
		closure[:fromAddress]  = "#{from_number} #{street}"
		closure[:toAddress]    = "#{to_number} #{street}"
		closure[:startDate]    = result_table.at(".//tr[#{row}]/td[6]").text.chomp
		closure[:endDate]      = result_table.at(".//tr[#{row}]/td[7]").text.chomp
		closure[:closureType]  = result_table.at(".//tr[#{row}]/td[8]").text.chomp

		for_a_lil_more_than_one_third_of_a_second = 0.334

		sleep for_a_lil_more_than_one_third_of_a_second # get around rate limiting; max 3 queries per second
		closure[:fromCoordinates] = geocode closure[:fromAddress]
		sleep for_a_lil_more_than_one_third_of_a_second # let's host our own pelias!
		closure[:toCoordinates]   = geocode closure[:toAddress]
		closures << closure
	end

	output_json[:closures] = closures

	File.open(outfile, 'a+') do |file|
	 	file.puts output_json.to_json
	end
end