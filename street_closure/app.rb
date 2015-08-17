require 'sinatra'
require 'rufus-scheduler'
require_relative 'scrape'

class ScrapeApp < Sinatra::Base

	set :run, true
	set :server, 'webrick'
	
  output_file = 'closure_coordinates.txt'

  get '/' do 'hi' end

  get '/closures' do
    send_file output_file
  end

  seconds_per_day = 24 * 60 * 60
  seconds_in_four_minutes = 4 * 60
  day = "#{day}s"
  four_minutes = "#{seconds_in_four_minutes}s"

  scheduler = Rufus::Scheduler.new
  scheduler.every day, :first_in => 0.1 do
    File.open(output_file, 'w') do |file|
      file.truncate 0
      file.puts street_closure_report
    end
  end

  keep_alive = Rufus::Scheduler.new
  keep_alive.every four_minutes, :first_in => 0.1 do
    p Net::HTTP.get(URI.parse(URI.encode("https://streetscrape.herokuapp.com/")))
    p Time.now.inspect
  end

	run! if app_file == $0
end