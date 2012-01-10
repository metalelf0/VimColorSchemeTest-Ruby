#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'thor'

class PictureDocument

	def initialize url, domain_name
		@document = Nokogiri::HTML(open(url))
		@domain_name = domain_name
	end

	def image_url
		download_link = @document.css('.download_link a')
		if download_link.empty?
			return nil
		else
			return download_link.first.attributes["href"].value
		end
	end

	def next_page_url
		next_page_url = @domain_name + @document.css('.prev a').first.attributes["href"].value
		puts next_page_url
		return next_page_url
	end
end

class NationalGeographicDownloader < Thor

	LAST_DOWNLOADED_PATH = '.last_download'


	desc 'download', 'Downloads pictures'
	method_option :number_of_pictures, :type => :numeric, :aliases => '-n', :default => 10
	method_option :starting_url, :type => :string, :aliases => '-s', :default => "http://photography.nationalgeographic.com/photography/photo-of-the-day"
	method_option :resume_from_last_download, :type => :boolean, :aliases => '-r', :default => false
	method_option :download_dir, :type => :string, :aliases => '-d', :default => './'
	method_options :force_overwrite => false
	def download
		domain_name = "http://photography.nationalgeographic.com"
		if options.resume_from_last_download
			begin
				File.open(LAST_DOWNLOADED_PATH, 'r') do |file|
					@url = file.gets
					puts @url
				end
			rescue Exception => e
				puts "Cannot retrieve last downloaded url, are you sure you already ran this script at least once?"
				exit 1
			end
		else
			@url = options.starting_url
		end
		number_of_downloaded_pictures = 0
		while number_of_downloaded_pictures <= options.number_of_pictures do
			picture_document = PictureDocument.new(@url, domain_name)
			image_url = picture_document.image_url
			if image_url
				# download picture
				print "Download link found in page at url #{@url}, proceeding..."
				target_path = File.join(options.download_dir, image_url.split('/').last)
				if File.exist?(target_path) && (options.force_overwrite != true)
					puts "Image #{target_path} already downloaded, exiting! Bye!"
					exit
				end
				system("wget #{image_url} -O #{target_path}  2>/dev/null")
				puts " [DONE]"
				number_of_downloaded_pictures = number_of_downloaded_pictures + 1
			else
				# skip and go to next page
				puts "Page at url #{@url} has no download link, skipping..."
			end
			@url = picture_document.next_page_url
		end
		puts "Last downloaded picture was at url #{@url}"
		File.open(LAST_DOWNLOADED_PATH, 'w') do |file|
			file.puts @url
		end
	end
end

NationalGeographicDownloader.start


