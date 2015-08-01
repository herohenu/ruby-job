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


require "em-synchrony"
require "em-synchrony/em-http"
require "em-synchrony/fiber_iterator"
require "json"

task  data:  :environment do 
  puts  "^^^^^^^^^^^ begin http  request  data ^^^^^^^^^^"
  tids = Topic.where(isdeal:false).pluck(:tid)
   urls = []
   tids = tids.map { |s| s.to_i }.sort!

   tids.each do  |tid|
     url = "https://ruby-china.org/api/v3/topics/#{tid}.json"
     urls.push(url)
    EventMachine.synchrony {
        http = EM::HttpRequest.new(url).get
        http.errback { p 'Error'; EM.stop }
        http.callback {
           req = http.response
           jsont = JSON.parse(req) 
           if   jsont['error'].nil?           
              t = jsont['topic']      
             ####################begin
               
               puts  "#{t['id']} ---------->#{t['title']} "
               tid =  t['id']
               findtopic = Topic.find_by(:tid => tid)
               puts " findtopic .nil?  #{findtopic.nil?}"
              puts  "find xxx ni l  " ,  findtopic.nil?
               if   !findtopic.isdeal?
                  puts "#{tid}===not deal======="
                   findtopic.update(  title:  t['title'],
                       pub_created_at:  t['created_at'],
                       pub_updated_at:  t['updated_at'],
                       replied_at:  t['replied_at'],
                       replies_count:  t['replies_count'],
                       node_name:  t['node_name'],
                       node_id:  t['node_id'],
                       last_reply_user_id:  t['last_reply_user_id'],
                       last_reply_user_login:  t['last_reply_user_login'],
                       user:  t['user'],
                       deleted:  t['deleted'],
                       abilities:  t['abilities'],
                       body:  t['body'],
                       body_html:  t['body_html'],
                       hits:  t['hits'],
                       isdeal:  true
                   )
               end
             ####################end          

           else
           puts  "#{tid}-------error:----> #{jsont['error']}"
           end


     
          EM.stop
        }
      }



   end



end



def  arry_insert
  arr = [ ]

   arr = arr.flatten!   
   arr = arr.map { |s| s.to_i }.sort!
   arr.each  do |tid|
      Topic.create(tid: tid ,  isdeal:  false)
   end
end
