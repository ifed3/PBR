require 'sinatra'
require 'rufus-scheduler'
require_relative 'scrape'

class ScrapeApp < Sinatra::Base

	set :run, true
	set :server, 'webrick'
	
  output_file = 'closure_coordinates.txt'

  get '/' do
    'hi'    
  end

  get '/closures' do
    send_file output_file
  end

  seconds_per_day = 24 * 60 * 60
  interval = "#{seconds_per_day}s"

  scheduler = Rufus::Scheduler.new
  scheduler.every interval, :first_in => 0.1 do
    File.open(output_file, 'w') do |file|
      file.truncate 0
      file.puts "Last updated at: #{Time.now}"; file.puts
    end
    scrape_street_closure_report output_file
  end

	run! if app_file == $0
end