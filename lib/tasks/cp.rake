task  :start  do 
	puts ' start  get  data ------>'
end

task :ask => :start do 
	puts 'how  are you '
end 

####em-http-request
require "em-synchrony"
require "em-synchrony/em-http"
require "em-synchrony/fiber_iterator"

task :storeData  => :environment  do 
   Model.where(conditions).find_each do |obj|
     obj.do_something
   end

end



#dianji  
#wait  
# get ids
#store 
#next  storage 
#






