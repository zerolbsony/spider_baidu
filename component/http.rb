# -*- coding:utf-8 -*-
require 'net/http'
class SocketClient
    @@fd = ''
    def fetch(url)
	response = Net::HTTP.get(HOST, url)
	body = response.force_encoding("utf-8")
	return body
    end
end
