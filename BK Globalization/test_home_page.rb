require 'selenium-webdriver'
require 'test/unit'
require 'phantomjs'
require 'net/https'
require_relative 'bk_lib.rb'

module Test
  class TestHomePage < Test::Unit::TestCase

    def setup
      @bk_lib = BKLib.new
      @driver = @bk_lib.driver
      @wait = @bk_lib.wait
      @country = 'UK'
      @where = 'QA'
      @driver.navigate.to(@bk_lib.select_country(@country, @where))
    end

    def teardown
    @driver.quit
  end

  #def test_home_page_title
  #  assert_equal('BURGER KING?', @driver.title)
  #end

    def test_visible_carousel_big_image
      verify_visible_image(:css, '.owl-item:not(.cloned) .big-img')
    end

    def test_visible_carousel_mobile_image
      verify_visible_image(:css, '.owl-item:not(.cloned) .mobile-img')
    end

    def test_all_buttons_have_valid_link
      ary = Array.new
      https = 'https'
      buttonList = @driver.find_elements(:css, 'a.bk-btn')
      buttonList.each do |i|
        #puts i.attribute('href')
        getlink = i.attribute('href')

        begin
          if getlink != nil
            if getlink.include?(https) == false
              #p getlink
              ary.push(getlink)
            end
          end
        rescue NoMethodError
          p "Error #{i}"
          next
        end

      end
      ary.uniq.each do |a|
        #puts a
        #res = Net::HTTP.get_response(URI(a))
        #res.basic_auth 'origin', 'openface!'
        #assert_not_equal('404', res.code, "This is error #{a}")
        req = Net::HTTP::Get.new(URI(a).request_uri)
        req.basic_auth 'origin', 'openface!'
        res = Net::HTTP.start(URI(a).hostname, URI(a).port) {|http|
          p http.request(req)
          # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
        }
      end
    end

    def test_home_take_a_break
      verify_visible_image_in_css(:css, 'div.content section.homeSocial .bg-left')
      verify_visible_image_in_css(:css, 'div.content section.homeSocial .bg-right')
      assert_not_nil(@driver.find_element(:css, 'section.homeSocial .title .top').text)
      assert_not_nil(@driver.find_element(:css, 'section.homeSocial .title .bot').text)
      assert @wait.until {@driver.find_element(:css, 'ul#flick-inflickity-clone').displayed?}
      assert element_present?(:css, 'ul#flick-inflickity-clone') # Check image on Flick
      verify_visible_image_in_instagram(:css, '#flickWrapper .item:first-child .front')
      verify_visible_image_in_instagram(:css, '#flickWrapper .item:first-child .bgFlip')
      verify_visible_image_in_instagram(:css, '#flickWrapper .item:last-child .front')
      verify_visible_image_in_instagram(:css, '#flickWrapper .item:last-child .bgFlip')
      assert @driver.find_element(:css, 'h4.subtitle').text.include?'swipe it, flip it, share it'
    end

    def test_home_find_restaurant
      verify_visible_image_in_find_restaurant(:css, 'section.homeMap')
      assert @driver.find_element(:css, 'div.swatch h4.title').text.include?'find a restaurant'
    end

    def test_home_our_story
      verify_visible_image_in_css(:css, 'section.ourStory')
      assert @driver.find_element(:css, 'section.ourStory h3.title').text.include?'SINCE 1954'
      assert_not_nil @driver.find_element(:css, 'section.ourStory h4.subtitle').text
    end

    def test_home_made_to_order
      verify_visible_image_in_css(:css, 'section.madeToOrder')
      assert @driver.find_element(:css, 'section.madeToOrder h3.title').text.include?'MADE TO ORDER'
      assert_not_nil @driver.find_element(:css, 'section.madeToOrder h4.subtitle').text
    end

    def test_home_bk_delivers
      verify_visible_image_in_css(:css, '.bkDelivers')
      assert @driver.find_element(:css, 'section.bkDelivers h3.title').text.include?'delivers'
      assert_not_nil @driver.find_element(:css, 'section.bkDelivers h4.subtitle').text
    end

    def test_home_bk_callouts
      #verify_visible_image_in_css(:css, '.bkCallouts')
      ##BK.com element##
      #assert_equal(2, how_many_rows(:css, 'section.bkCallouts .row .col-sm-3'))
      #@driver.find_elements(:css, 'section.bkCallouts .row .col-sm-3').each do |c|
      #  assert_not_nil c.text
      #end

      ##BK UK element##
      assert_equal(2, how_many_rows(:css, 'section.bkCallouts .row .col-sm-6'))
      @driver.find_elements(:css, 'section.bkCallouts .row .col-sm-6').each do |c|
        assert_not_nil c.text
      end
    end




    def verify_visible_image(how, what)
      begin
        imgList = @driver.find_elements(how, what)
        imgList.each do |i|
          #puts i.attribute('src')
          #res = Net::HTTP.get_response(URI(i.attribute('src')))
          #assert_equal('200', res.code, "This is error #{i.attribute('src')}")
          p httpstring = i.attribute('data-src')
          req = Net::HTTP::Get.new(URI(httpstring).request_uri)
          #req.basic_auth 'origin', 'openface!'
          Net::HTTP.start(URI(httpstring).hostname, URI(httpstring).port) {|http|
            p http.request(req)
            # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
            assert_match(/200/, http.request(req).code)
          }
          # assert_equal('200', res.code, "This is error #{i.attribute('src')}")
        end
      rescue Selenium::WebDriver::Error::NoSuchElementError
        p "Error #{what}"
      end

    end

    def verify_visible_image_in_css(how, what)
      begin
        imgListCSS = @driver.find_element(how, what)
        puts imgListCSS.css_value('background-image')
        urlString = imgListCSS.css_value('background-image')
        urlArray = urlString.split('(')
        url = urlArray[1].split(')')
        splitString = urlString.split('origin:openface!@')
        joinString = splitString.join
        p httpstring =  joinString.slice!(/h.*g/)
        #res = Net::HTTP.get_response(URI('http://qa.burgerking.co.uk/img/gutter/left/L_coffee.jpg'))
        req = Net::HTTP::Get.new(URI(httpstring).request_uri)
        req.basic_auth 'origin', 'openface!'
        Net::HTTP.start(URI(httpstring).hostname, URI(httpstring).port) {|http|
          #p http.request(req)
          assert_match(/200/, http.request(req).code)
          # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
        }
          #assert_equal('200', res.code, "This is error #{url[0]}")
      rescue Selenium::WebDriver::Error::NoSuchElementError
        p "Error #{what}"
      end
    end

    def verify_visible_image_in_find_restaurant(how, what)
      begin
        imgListCSS = @driver.find_element(how, what)
        puts imgListCSS.css_value('background-image')
        urlString = imgListCSS.css_value('background-image')
        urlArray = urlString.split('(')
        url = urlArray[1].split(')')
        p httpstring =  url.join
        #res = Net::HTTP.get_response(URI('http://qa.burgerking.co.uk/img/gutter/left/L_coffee.jpg'))
        req = Net::HTTP::Get.new(URI(httpstring).request_uri)
        #req.basic_auth 'origin', 'openface!'
        res = Net::HTTP.start(URI(httpstring).hostname, URI(httpstring).port) {|http|
          p http.request(req)
          # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
        }
          #assert_equal('200', res.code, "This is error #{url[0]}")
      rescue Selenium::WebDriver::Error::NoSuchElementError
        p "Error #{what}"
      end
    end

    def verify_visible_image_in_instagram(how, what)
      begin
        imgListCSS = @driver.find_element(how, what)
        #puts imgListCSS.css_value('background-image')
        urlString = imgListCSS.css_value('background-image')
        urlArray = urlString.split('(')
        url = urlArray[1].split(')')
        sliceUrl = url.join
        #uri = URI.parse(url)

        ##HTTPS url##
        uri = URI.parse(sliceUrl)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
        #p http.get(uri.request_uri)
        assert_match(/200/, http.get(uri.request_uri).code)
      rescue Selenium::WebDriver::Error::NoSuchElementError
        p "Error #{what}"
      end
    end

    def how_many_rows(how, what)
      rowList = @driver.find_elements(how, what)
      rowList.size()
    end

    def element_present?(how, what)
      found = @driver.find_element(how => what)
      if found
        true # return true if this element is found
      else
        false # return false if this element is not found
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError # catch if NoSuchElementError appears
      false
    end


  end
end