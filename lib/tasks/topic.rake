require 'rest-client'
require 'nokogiri'

desc "get total jobs  "
task step1: :environment do
  puts ' start 2   ------>'
  total = []
  ######### kown  job pages  at first ###############
  (1..103).each do |index|

    joburl = 'https://ruby-china.org/jobs?page='<< index.to_s
    response = RestClient::Request.execute(method: :get, url: joburl, timeout: 500)

    page = Nokogiri::HTML(response)
    current_topics = page.css("div .topic")
    arr = []
    current_topics.map do |node|
      values = node.values[0]
      classarr = values.split(' ')
      topic_id = classarr.last
      tids = topic_id.split('-').last
      #todo  add if is exists  in db
      Topic.create(:tid => tids.to_i)
      arr.push tids
    end
    total.push arr
  end
  p "total is : ", total
end


require "em-synchrony"
require "em-synchrony/em-http"
require "em-synchrony/fiber_iterator"
require "json"
desc "store topic info to db "
task step2: :environment do

  tids = Topic.where(isdeal: false).pluck(:tid)
  urls = []
  tids = tids.map { |s| s.to_i }.sort!

  tids.each do |tid|
    url = "https://ruby-china.org/api/v3/topics/#{tid}.json"
    urls.push(url)
    EventMachine.synchrony {
      http = EM::HttpRequest.new(url).get
      http.errback { p 'Error'; EM.stop }
      http.callback {
        req = http.response
        jsont = JSON.parse(req)
        if jsont['error'].nil?
          t = jsont['topic']
          puts "#{t['id']} ---------->#{t['title']} "
          tid = t['id']
          findtopic = Topic.find_by(:tid => tid)
          if !findtopic.isdeal?
            findtopic.update(title: t['title'],
                             pub_created_at: t['created_at'],
                             pub_updated_at: t['updated_at'],
                             replied_at: t['replied_at'],
                             replies_count: t['replies_count'],
                             node_name: t['node_name'],
                             node_id: t['node_id'],
                             last_reply_user_id: t['last_reply_user_id'],
                             last_reply_user_login: t['last_reply_user_login'],
                             user: t['user'],
                             deleted: t['deleted'],
                             abilities: t['abilities'],
                             body: t['body'],
                             body_html: t['body_html'],
                             hits: t['hits'],
                             isdeal: true
            )
          end
          ####################end
        else
          puts "#{tid}-------error:----> #{jsont['error']}"
        end
        EM.stop
      }
    }
  end

end


def arry_insert
  arr = []
  arr = arr.flatten!
  arr = arr.map { |s| s.to_i }.sort!
  arr.each do |tid|
    Topic.create(tid: tid, isdeal: false)
  end
end
## get topic has been removed 
#  tids = Topic.where(isdeal:false).pluck(:tid)
