require 'tiny_tds'

client = TinyTds::Client.new(:username => 'qa', :password => 'openface', :host => 'PEACH', :database => 'test', :port => '51700')
p "isConnection Dead = #{client.dead?}"
p "isConnection Close = #{client.closed?}"
p "isConnection Active = #{client.active?}"
result = client.execute("select * from dbo.mytable")
result.each { |row| puts "#{row}" }