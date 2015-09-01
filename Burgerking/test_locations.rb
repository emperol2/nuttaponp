require 'selenium-webdriver'
require 'test/unit'
require 'phantomjs'
require 'net/http'
require_relative 'bk_lib'

include BK_lib

module Test
  class TestLocations < Test::Unit::TestCase

    def setup
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 300
      @driver = Selenium::WebDriver.for :phantomjs, :http_client => client
      #@driver.navigate.to('http://www.burgerking.co.uk')
      @rootURL = SITE_URL
      @driver.manage.timeouts.implicit_wait = 20
      @driver.manage.timeouts.script_timeout = 20
      @wait = Selenium::WebDriver::Wait.new :timeout => 30
      @verification_errors = []
    end

    def teardown
      @driver.quit
      p @verification_errors
    end

    # def test_fresh_taste
    #   @driver.navigate.to("#{@rootURL}/our-story")
    #
    #   # Title
    #   assert get_title.include?'Our story'
    #
    #   # How many Slider
    #   sliderSize = @driver.find_elements(:css, 'div.owl-item').size
    #   assert_not_equal 0, sliderSize, 'This area should not be zero item'
    #
    #   # Left and Right Arrow
    #   assert element_present?(:css, 'div.owl-prev .arrow'), 'Left arrow should display here'
    #   assert element_present?(:css, 'div.owl-next .arrow'), 'Right arrow should display here'
    #
    #   # Prev Slider
    #   @driver.find_element(:css, 'div.owl-prev .arrow').click
    #   sleep 2
    #   descText = @driver.find_element(:css, 'div.active.center .desc-header').text
    #   assert_not_empty descText, 'This should not be empty'
    #
    #   # Check System Error Msg
    #   show_system_error_msg?
    #
    #   #@driver.save_screenshot "C:/LayoutDiff/LiveCapture/IE/testxxx.png"
    # end

    def test_aboutBK
      @driver.navigate.to("#{@rootURL}/about-bk")

      # Page Title
      assert get_title.include?'About Us'

      # Content block + content
      assert_not_empty @driver.find_element(:css, 'section div.content').text, 'This should not be empty'

      # Find Legal
      findText = @driver.find_element(:css, 'section div.content').text
      assert findText.include?'second largest fast food hamburger'

      # Check System Error Msg
      show_system_error_msg?

      # Check Visible image
      visible_image?

      # # background image
      # @wait.until { @driver.find_element(:xpath, '/html/body/section[2]').css_value('background-image') != "none" }
      # bkImg = @driver.find_element(:xpath, '/html/body/section[2]').css_value('background-image')
      # Net::HTTP.get_response(URI(bkImg))
      # assert_equal('200', res.code, "This is error #{bkImg}")
    end


    def test_xx
      uri = URI('http://originqa.bk.com/img/logo-googlePlay.png')

      req = Net::HTTP::Get.new(uri.request_uri)
      req.basic_auth 'origin', 'openface!'

      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }
      puts res.code
      assert res.code.include?'200'
    end

    def get_title
      @driver.title
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

    def verify_test(&blk)
      yield
    rescue MiniTest::Assertion => ex
      @verification_errors << ex
    end

    def show_system_error_msg?
      assert element_present?(:css, '.system-message') == false, 'This ERROR should not be displayed'
    end

    def visible_image?
      imgList = @driver.find_elements(:tag_name, 'img')
      if imgList
        imgList.each do |i|
          if LIVE_SITE == true
            res = Net::HTTP.get_response(URI(i.attribute('src')))
            assert_equal('200', res.code, "This is error #{i.attribute('src')}")
          else
            # p httpstring = i.attribute('src')
            req = Net::HTTP::Get.new(URI(i.attribute('src')).request_uri)
            req.basic_auth QA_USERNAME, QA_PASSWORD
            res = Net::HTTP.start(URI(i.attribute('src')).hostname, URI(i.attribute('src')).port) {|http|
              p http.request(req)
              # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
            }
            puts res.code
            assert res.code.include?'200'
          end
        end
      else
        false
        p "There is no image on this page #{@driver.current_url}"
      end
    end

  end
end