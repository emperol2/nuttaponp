require 'selenium-webdriver'
require 'test/unit'
require 'phantomjs'

module Test
  class TestMenuPage < Test::Unit::TestCase

    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @driver.navigate.to('http://origin:openface!@originqa.bk.com/menu')
      @driver.manage.timeouts.implicit_wait = 40
      @wait = Selenium::WebDriver::Wait.new :timeout => 40
    end

    def teardown
      @driver.quit
    end

    def test_visible_image_menu
      imgList = @driver.find_elements(:tag_name, 'img')
      imgList.each do |i|
        #puts i.attribute('src')
        p httpstring = i.attribute('src')
        # httpstrings = httpstring.gsub(/\/+/, '//origin:openface!@')
        # res = Net::HTTP.get_response(URI(httpstrings))
        req = Net::HTTP::Get.new(URI(httpstring).request_uri)
        req.basic_auth 'origin', 'openface!'
        res = Net::HTTP.start(URI(httpstring).hostname, URI(httpstring).port) {|http|
          p http.request(req)
          # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
        }
        # assert_equal('200', res.code, "This is error #{i.attribute('src')}")

      end
    end


    def test_visible_image_submenu
      ary = Array.new
      cagetoryList = @driver.find_elements(:css, '.food-category a')
      cagetoryList.each do |c|
        ary.push(c.attribute('href'))
      end

      ary.each do |a|
        @driver.navigate.to(a)
        imgList = @driver.find_elements(:tag_name, 'img')
        imgList.each do |i|
          #puts i.attribute('src')
          res = Net::HTTP.get_response(URI(i.attribute('src')))
          assert_equal('200', res.code, "This is error #{i.attribute('src')}")
        end
      end
    end

    def test_deadlink_menu
      ary = Array.new
      bk_us = 'www.bk.com'
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
          p "Error #{i.text}"
          next
        end

      end
      ary.uniq.each do |a|
        puts a
        res = Net::HTTP.get_response(URI(a))
        assert_not_equal('404', res.code, "This is error #{a}")
        # if res.code == '200'
        #   assert_equal('200', res.code, "This is error #{a}")
        # else
        #   assert_equal('301', res.code, "This is error #{a}")
        # end
        #assert_equal('301', res.code, "This is error #{a}")
      end
    end


  end
end