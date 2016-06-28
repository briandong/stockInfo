#!/usr/bin/env ruby
# This small script takes a stock index list (as sample_list) as input, and retrieves the real-time info - PE ratio

# Open required libraries
require 'rubygems'
require 'watir'
#require 'nokogiri'
#require 'open-uri'

# Get the stock index list
if ARGV.size == 0
	puts "Please specify the stock index list"
	exit
else
	stock_list = File.open(ARGV[0]) if File.file?(ARGV[0])

	#open the browser
	browser = Watir::Browser.new :chrome
	
	# the URL is like "http://finance.sina.com.cn/realstock/company/sh601988/nc.shtml"
	stock_list.each do |line|
		# get stock index
		index = line.split(' ')[0]
		if index.to_i >= 600000 #SH
			index = "sh" + index
		else #SZ
			index = "sz" + index
		end

		#puts "Getting stock information: #{index}"

		url = "http://finance.sina.com.cn/realstock/company/#{index}/nc.shtml"
		begin
			Timeout::timeout(90) do
				browser.goto url
				content = browser.html
				#puts content

				#get the PE value
				if content =~ /\<sup\>(TTM|MRQ)\<\/sup\>.*\n.*\<td\>([\d\.\-,]*)\<\/td\>/
					puts $2
				else
					puts "Error: cannot get PE for stock \'#{index}\'"
				end
			end
		rescue Timeout::Error => e
			puts e.message
		end
		
	end

	stock_list.close

	#close the browser
	browser.close

end
