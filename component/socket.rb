# -*- coding:utf-8 -*-
require 'socket'
class SocketClient
    @@fd = ''
    def initialize(host, port)
	@@fd = TCPSocket.open(host, port)
    end
    def fetch(url)
	#    @@fd = TCPSocket.open(HOST, PORT)
	#    url = '/s?wd=ruby'
	#    @@fd.print("POST #{url} HTTP/1.0\r\n\r\n")
	#else
	    @@fd.print("GET #{url} HTTP/1.0\r\n\r\n")
	#end
	#@@fd.print("GET #{url} HTTP/1.0\r\nAccept: html/text\r\nHost: www.baidu.com\r\nConnection: keep-alive\r\nUser-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101 Firefox/34.0\r\n")
	response = @@fd.read
	if url.length() > 20
	    #puts "li"+response+"bo"
	end
        headers,body = response.split("\r\n\r\n",2)
	body = body.force_encoding("utf-8")
	return body
    end
end
