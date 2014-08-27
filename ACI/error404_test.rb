require 'test/unit'
require 'selenium-webdriver'
require 'open-uri'
require 'nokogiri'
require 'open_uri_redirections'
require 'openssl'
require 'date'

class ErrorStatusTest < Test::Unit::TestCase
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 10
    @verification_errors = []
    @baseURL = 'http://www.aci.aero/'
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit()
  end

  # Fake test
  def test_fail

    fail('Not implemented')
  end

  def test_error404

    # aci_website = @driver.get(@baseURL)

    # fail("Usage: extract_links URL [URL ...]") if ARGV.empty?

    # ARGV.each do |url|
    #   doc = Nokogiri::HTML(open(url))
    #   hrefs = doc.css("a").map do |link|
    #     if (href = link.attr("href")) && !href.empty?
    #       URI::join(url, href)
    #     end
    #   end.compact.uniq
    #   STDOUT.puts(hrefs.join("\n"))
    # end
    @driver.get(@baseURL)
    error404_file = File.new('C:\Users\nuttapon\Documents\ACI\error404.txt', 'a')
    error404_file.puts "#{DateTime.now.to_s} We are verifying this site #{@baseURL} \n\n"

    doc = Nokogiri::HTML(open(@baseURL))
    hrefs = doc.css("a").map do |link|
      if (href = link.attr("href")) && !href.empty?
        link = URI.encode(href)
        URI::join(@baseURL, URI.parse(link))
      end
    end.compact.uniq
    # puts(hrefs.join("\n"))

    hrefs.each do |x|
      #p x.to_s
      if x.to_s.include? 'https'
        #p "Link contains 'https' #{x.to_s}"
        error404_file.puts "Link contains 'https' #{x.to_s}"
      elsif x.to_s.include? 'mailto'
        #p "Link contains 'mailto' #{x.to_s}"
        error404_file.puts "Link contains 'mailto' #{x.to_s}"
      elsif x.to_s.include? 'javascript'
        #p "Link contains 'generic' #{x.to_s}"
        error404_file.puts "Link contains 'generic' #{x.to_s}"
      else
        begin # try
          open_href = open(x, :allow_redirections => :safe)
          if open_href.status[0] != '200'
            #p "The URL #{x.to_s} has status code - #{open_href.status[0]} and status message #{open_href.status[1]}"
            error404_file.puts "The URL #{x.to_s} has status code - #{open_href.status[0]} and status message #{open_href.status[1]}"
          end
        rescue # catch if there is any error during the website open
          p "There is an error exception here #{x.to_s}"
          false
        end # End Try Catch
      end
    end
    error404_file.close

  end # End Error 404 Test case

end