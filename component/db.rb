# -*- coding:utf-8 -*-
require File.dirname(__FILE__) + '/../conf/config.rb'
require 'mysql'
class Db
    @@conn = false
    def initialize
	begin
	    @@conn = Mysql.real_connect(DB_HOST, DB_USER, DB_PWD, DB_NAME, DB_PORT)
	    return @@conn
	rescue MysqlError => e
	    puts "[#{e.errno}] #{e.error}\n";
	end
    end

    def query(sql)
	return @@conn.query(sql)
    end

    def destruct
	@@conn.close
    end
end

#db = Db.new
#rs = db.query("SELECT * FROM pay_city")
#rs.each_hash do |r|
#    puts "#{r['city_host']}\n"
#end
#db.destruct
