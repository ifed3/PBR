require 'sinatra'
require 'rufus-scheduler'
require_relative 'scrape'

class ScrapeApp < Sinatra::Base

	set :run, true
	set :server, 'webrick'
	
  get '/' do
    'ping'    
  end

  file_name = 'closure_coordinates.txt'

  seconds_per_day = 86400
  interval = "#{seconds_per_day}s"

  scheduler = Rufus::Scheduler.new
  scheduler.every interval do
    File.open(file_name, 'w') do |file|
      file.truncate 0
      file.puts 
    end
    scrape_street_closure_report file_name
  end

	run! if app_file == $0
end