task  :start1  do 
	puts ' start1   ------>'

require 'rest-client'
require 'nokogiri'      

joburl = 'https://ruby-china.org/jobs?page=1'
response =  RestClient.get  joburl
response.code 
response.to_str
page = Nokogiri::HTML( response)   
#puts page.class   # => Nokogiri::HTML::Document
current_topics = page.css("div .topic")
arr = []
current_topics.map do  |node|	
	values = node.values[0]
	classarr = values.split(' ')
	topic_id = classarr.last
	tids = topic_id.split('-').last
	arr.push tids
	
end

p  " current_topics :: " ,arr



end




