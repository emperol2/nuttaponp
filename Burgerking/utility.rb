require 'net/http'

class Utilities

  uri = URI('http://originqa.bk.com/img/logo-googlePlay.png')

  req = Net::HTTP::Get.new(uri.request_uri)
  req.basic_auth 'origin', 'openface!'

  res = Net::HTTP.start(uri.hostname, uri.port) {|http|
    http.request(req)
  }
  puts res.code
  assert res.code.include?'200'

  def myfuntion
    x = 1 + 1
    puts x
  end

end