#!/usr/local/ruby/bin/ruby -w
# -*- coding:utf-8 -*-
require File.dirname(__FILE__) + '/conf/config.rb'
require File.dirname(__FILE__) + '/application/client.rb'
application = Client.new(HOST,PORT,BASE_URL+WORD)
application.run
