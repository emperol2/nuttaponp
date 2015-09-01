require 'selenium-webdriver'
require 'test/unit'
#require 'phantomjs'
require_relative 'bk_lib'

include BK_lib

module Test
  class TestMenuPage < Test::Unit::TestCase

    def setup
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 300
      @driver = Selenium::WebDriver.for :phantomjs, :http_client => client
      @rootURL = 'http://www.bk.com'
      @rootURL = SITE_URL
      #@driver.navigate.to('http://originstg.bk.com/menu')
      @driver.manage.timeouts.implicit_wait = 60
      @wait = Selenium::WebDriver::Wait.new :timeout => 25
    end

    def teardown
      @driver.quit
    end

    def test_visible_image_menu
      @driver.navigate.to("#{@rootURL}/menu")
      # imgList = @driver.find_elements(:tag_name, 'img')
      # imgList.each do |i|
      #   #puts i.attribute('src')
      #   res = Net::HTTP.get_response(URI(i.attribute('src')))
      #   assert_equal('200', res.code, "This is error #{i.attribute('src')}")
      # end
      visibleProductImage?
    end


    def test_visible_image_submenu
      @driver.navigate.to("#{@rootURL}/menu")
      ary = Array.new
      cagetoryList = @driver.find_elements(:css, '.food-category a')
      cagetoryList.each do |c|
        ary.push(c.attribute('href'))
      end

      ary.each do |a|
        @driver.navigate.to(a)
        # imgList = @driver.find_elements(:tag_name, 'img')
        # imgList.each do |i|
        #   #puts i.attribute('src')
        #   res = Net::HTTP.get_response(URI(i.attribute('src')))
        #   assert_equal('200', res.code, "This is error #{i.attribute('src')}")
        # end
        visibleProductImage?
      end
    end

    def test_deadlink_menu
      @driver.navigate.to("#{@rootURL}/menu")
      ary = Array.new
      bk_us = @rootURL
      addthis = 'addthis'
      linkList = @driver.find_elements(:tag_name, 'a')
      linkList.each do |i|
        #puts i.attribute('href')
        getlink = i.attribute('href')

        begin
          if getlink.include?(bk_us)
            if getlink.include?(addthis) == false
              #p getlink
              ary.push(getlink)
            end
          end
        rescue NoMethodError
          p "URL Error: #{i.attribute('innerHTML')}"
          next
        end

      end
      ary.uniq.each do |a|
        begin
          if LIVE_SITE == true
            res = Net::HTTP.get_response(URI(a))
            assert_not_equal('404', res.code, "This is error #{a}")
          else
            # p httpstring = i.attribute('src')
            req = Net::HTTP::Get.new(URI(a).request_uri)
            req.basic_auth QA_USERNAME, QA_PASSWORD
            res = Net::HTTP.start(URI(a).hostname, URI(a).port) {|http|
              http.request(req)
              # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
            }
            #puts res.code
            just_verify { assert res.code.include?'200' }
          end
        rescue NoMethodError => e
          p "Exception links: #{a}"
          next
        end
      end
    end


  end
end