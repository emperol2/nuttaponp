require 'net/http'
require 'uri'

# uri = URI('http://qa.burgerking.com.br/atencion-al-cliente')
# req = Net::HTTP::Get.new(URI(uri).request_uri)
# req.basic_auth 'origin', 'openface!'
# p response = Net::HTTP.get_response(URI(uri))
# p location = response['location']
#
# final_destination = URI(location)
# req2 = Net::HTTP::Get.new(URI(final_destination).request_uri)
# req2.basic_auth 'origin', 'openface!'
# p response = Net::HTTP.get_response(URI(final_destination))
# p location = response['location']

# p Net::HTTP.get_response(URI.parse('http://www.google.com'))['location']


x = File.open('C:/Users/nuttapon/Downloads/test.txt','r:iso-8859-1:utf-8').read
x.each_line do |line|

  line.gsub!(/\n/, "")
  p encode_url = URI.encode(line)
  uri = URI(encode_url)
  req = Net::HTTP::Get.new(uri.request_uri)
  #req.basic_auth 'origin', 'openface!'

  res = Net::HTTP.start(uri.hostname, uri.port) {|http|
    http.request(req)
  }

  p res.code
  # puts res.body

  if res.code == "301"

    puts final_destination = res['location']
    final_destination = URI.encode(final_destination)
    final_destination = URI(final_destination)

    req2 = Net::HTTP::Get.new(final_destination.request_uri)
    #req2.basic_auth 'origin', 'openface!'

    res2 = Net::HTTP.start(final_destination.hostname, final_destination.port) {|http|
      http.request(req2)
    }

    p res2.code

    puts line

    File.open('C:/Users/nuttapon/Downloads/output.txt', 'a+') { |file| file.write("URL: #{encode_url} \n\nResponse from Origin:  #{res.code}, Response from Destination: #{res2.code} \n\n" ) }

  else

    File.open('C:/Users/nuttapon/Downloads/output.txt', 'a+') { |file| file.write("URL: #{encode_url} \n\nResponse from Origin #{res.code} \n\n" ) }

  end

end


############### SEO Redirects #################

# p encode_url = URI.encode('http://stg.burgerking.com.br/combos/165/club+bk®')
# p uri = URI(encode_url)
# req = Net::HTTP::Get.new(uri.request_uri)
#   req.basic_auth 'origin', 'openface!'
#
#   res = Net::HTTP.start(uri.hostname, uri.port) {|http|
#     http.request(req)
#
#   }
#  p res.code
#   # puts res.body
#   puts final_destination = res['location']
#   final_destination = URI.encode(final_destination)
#   final_destination = URI(final_destination)
#
# req2 = Net::HTTP::Get.new(final_destination.request_uri)
# req2.basic_auth 'origin', 'openface!'
#
# res2 = Net::HTTP.start(final_destination.hostname, final_destination.port) {|http|
#   http.request(req2)
#
# }
#
# p res2.code