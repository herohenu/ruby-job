#just for  test  rake   useage
task :start do
  puts ' start  get  data ------>'
end

task :ask => :start do
  puts 'how  are you '
end


require "em-synchrony"
require "em-synchrony/em-http"
require "em-synchrony/fiber_iterator"
require "json"
#ActiveSupport::JSON.decode("{\"team\":\"rails\",\"players\":\"36\"}")
#https://github.com/igrigorik/em-synchrony
#https://ruby-china.org/api/v3/topics/26443.json
#
task :req => :environment do
  tids = Topic.where(isdeal: false).pluck(:tid)
  tids2 =[]
  urls = []
  tids2 = tids.map { |s| s.to_i }.sort!

  tids2.each do |tid|
    prefix = "https://ruby-china.org/api/v3/topics/#{tid}.json"
    urls.push(prefix)
  end
  #urls = urls[1..2]
  EM.synchrony do
    concurrency = 2
    results = []
    EM::Synchrony::FiberIterator.new(urls, concurrency).each do |url|
      resp = EventMachine::HttpRequest.new(url).get
      results.push resp.response
    end

    # puts results # all completed requests
    results.each do |elem|
      jsont = ActiveSupport::JSON.decode(elem)
      topic = jsont['topic']
      t = topic
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
    end
    EventMachine.stop
  end


end

puts "###############  results ###############"
