require 'rest-client'
require 'nokogiri'     


task  start2:   :environment do	
puts ' start 2   ------>'
total = []

	(1..103).each  do  |index| 
   
	joburl = 'https://ruby-china.org/jobs?page='<< index.to_s
	#puts   joburl 

	response =  RestClient::Request.execute(method: :get, url: joburl,timeout: 500)

	page = Nokogiri::HTML( response)   
	current_topics = page.css("div .topic")
		arr = []
		current_topics.map do  |node|		
			values = node.values[0]
			classarr = values.split(' ')
			topic_id = classarr.last
			tids = topic_id.split('-').last
			puts  tids
			Topic.create(:tid => tids.to_i)
			arr.push tids			
		end
	   # p   ' current_page '  +  index.to_s  +  ' topic ids  :' ,arr
                total.push arr
end
    p  "total is : " ,total 
 end 
