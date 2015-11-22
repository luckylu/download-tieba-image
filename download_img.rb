require 'open-uri'
require 'nokogiri'

module Tieba
	module Post
		def self.fetch_img_url(url, pagenum)
			@img_url = []
			(1..pagenum).each do |num|
				doc = Nokogiri::HTML(open(url+"?pn=#{num}"))
				doc.xpath('//title').each do |title|
				  @folder_name = title.content
				end
				doc.css('.d_post_content>img.BDE_Image').each do|content|
					@img_url.push content.attribute('src').to_s.sub(/w\%3D580\/sign.*\//,"pic\/item\/")
				end
			end
		end

		def self.download_img(url, pagenum)
			fetch_img_url(url, pagenum)
			`mkdir "#@folder_name"`
			@img_url.each_with_index do |url,index|
				open(url) {|f|
				   File.open("./#@folder_name/#{index}.jpg","wb") do |file|
				     file.puts f.read
				   end
				}
			end
		end
	end
end

Tieba::Post.download_img(ARGV[0],ARGV[1].to_i)