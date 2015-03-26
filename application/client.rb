# -*- coding:utf-8 -*-
require File.dirname(__FILE__) + '/../conf/config.rb'
#require File.dirname(__FILE__) + '/../component/socket.rb'
require File.dirname(__FILE__) + '/../component/http.rb'
require File.dirname(__FILE__) + '/../component/db.rb'
class Client
    @@url = ''
    @@host = ''
    @@port = 0
    @@count = 0
    @@socket = ''
    @@threads = []
    def initialize(host, port, url)
	@@url = url
	@@host = host
	@@port = port
    end
    def run
	@@socket = SocketClient.new
	queue = Queue.new
	url_queue = Queue.new
	response = @@socket.fetch(@@url)
	cur_words = self.parse(response)
	#max_word_count = MAX_WORD_COUNT - cur_words.size.to_i
	cur_words.each { |word|
	    queue << word['key']
	    url_queue << word['url']
	}

	MAX_THREAD_COUNT.times do |i|
	    producer = Thread.new do
		while url_queue.length() > 0 do
		    response = @@socket.fetch(url_queue.pop)
		    cur_words = self.parse(response)
		    cur_words.each { |word|
			if queue.length() < MAX_WORD_COUNT
		            queue << word['key']
	    	            url_queue << word['url']
			end
		    }
		end
	    end
	    producer.join
	end
	puts queue.length()
    end
    #def spiderWord(word,thread)
#	    response = @@socket.fetch(word['url'])
#	    cur_words = self.parse(response)
#	    cur_words.each { |word|
#	      m.synchronize {
 #               if @@count < MAX_WORD_COUNT
#		    if self.insert2keyword(word['key'])
 #                       @@count = @@count+1
#			#记录检索的10条标题和域名到数据库中
#			cur_results = self.parseResult(response)
#			cur_results.each {
#			    |result|
#			    self.insert2record(result)
#			}
#			if @@count < MAX_WORD_COUNT
 #                           self.spiderWord(word,thread)
#			else
#			    Thread.kill(thread)
#			end
#		    end
#		else
#		    Thread.kill(thread)
 #               end
#	      }
 #           }
 #   end
    def parse(string)
	result = []
	matches = /<div class="tt">相关搜索<\/div><table[^>]+>(.*)<\/table>/.match(string)
	matches[1].scan(/<th><a href="([^"]+)">([^<]+)<\/a><\/th>/).each{
            |th|
            result.push({'url'=>th[0], 'key'=>th[1]})
	}
	return result
    end
    def parseResult(string)
	result = []
	string.scan(/(<h3 class="t"><a(?:(?!<\/a>)\S|\s)*<\/a><\/h3>)+/).each{
	    |th|
	    result.push({ 'title' => th[0].gsub(/<\/?[^>]+>/, '') })
	}
	i = 0
	string.scan(/(<span class="g">((?!<\/span>).)*<\/span>)+/).each{
	    |th|
	    matches = /^(http:\/\/)?([^\/]+)\/.*$/.match(th[0].gsub(/<\/?[^>]+>/, ''))
	    result[i]['host'] = matches[2]
	    i = i+1
	}
	return result
    end
    def insert2keyword(word)
	db = Db.new
	rs = db.query("INSERT INTO keywords VALUES (NULL, '#{word}')")
	if rs
	    return true
	else
	    return false
	end
	db.close
    end
    def insert2record(data)
	db = Db.new
	rs = db.query("INSERT INTO keywords VALUES (NULL, '#{data['title']}', '#{data['host']}')")
	if rs
	    result = true
	else
	    result = false
	end
	db.destruct
	return result
    end
end
