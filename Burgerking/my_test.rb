require 'selenium-webdriver'
require 'test/unit'
require 'minitest'
#require 'phantomjs'
require_relative 'bk_lib'

include BK_lib

module Test
  class TestHomePage < Test::Unit::TestCase

    def setup
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 300
      @driver = Selenium::WebDriver.for :phantomjs, :http_client => client
      #@rootURL = 'http://www.bk.com'
      @rootURL = SITE_URL
      @driver.manage.timeouts.implicit_wait = 60
      @wait = Selenium::WebDriver::Wait.new :timeout => 60
    end

    def teardown
      @driver.quit
    end

    #def test_home_page_title
    #  assert_equal('BURGER KING®', @driver.title)
    #end

    def test_visible_carousel_big_image
      @driver.navigate.to(@rootURL)
      p @driver.find_elements(:css, '.owl-item:not(.cloned) .big-img')
      begin
        @wait.until {element_present?(:css, '.owl-item:not(.cloned) .big-img') == true}
      rescue Selenium::WebDriver::Error::TimeOutError
        p "TimeOutError"
      end
      verify_visible_image(:css, '.owl-item:not(.cloned) .big-img')
    end

    def test_visible_carousel_mobile_image
      @driver.navigate.to(@rootURL)
      begin
        @wait.until {@driver.find_elements(:css, '.owl-item:not(.cloned) .mobile-img').displayed? == true}
      rescue Selenium::WebDriver::Error::TimeOutError
        p "TimeOutError"
      end
      verify_visible_image(:css, '.owl-item:not(.cloned) .mobile-img')
    end

    def test_all_buttons_have_valid_link
      @driver.navigate.to(@rootURL)
      ary = Array.new
      https = 'https'
      buttonList = @driver.find_elements(:css, 'a.bk-btn')
      p "Found: #{buttonList.size()}"
      buttonList.each do |i|
        #puts i.attribute('href')
        getlink = i.attribute('href')

        begin
          if getlink != nil
            if getlink.include?(https) == false
              #p getlink
              ary.push(getlink)
            else
              p "This link contains HTTPS: #{getlink}"
            end
          else
            p "This link is NULL: #{getlink}"
          end
        rescue NoMethodError
          p "This link is Error #{i}"
          next
        end

      end
      ary.uniq.each do |a|
        puts a
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

    def test_home_take_a_break
      @driver.navigate.to(@rootURL)
      verify_visible_image_in_css(:css, 'section.homeSocial .bg-left')
      verify_visible_image_in_css(:css, 'section.homeSocial .bg-right')
      assert_not_nil(@driver.find_element(:css, 'section.homeSocial .title .top').text)
      assert_not_nil(@driver.find_element(:css, 'section.homeSocial .title .bot').text)
      assert @wait.until {@driver.find_element(:css, 'ul#flick-inflickity-clone').displayed?}
      assert element_present?(:css, 'ul#flick-inflickity-clone') # Check image on Flick
      verify_visible_image_in_css(:css, '#flickWrapper .item:first-child .front')
      verify_visible_image_in_css(:css, '#flickWrapper .item:first-child .bgFlip')
      verify_visible_image_in_css(:css, '#flickWrapper .item:last-child .front')
      verify_visible_image_in_css(:css, '#flickWrapper .item:last-child .bgFlip')
      assert @driver.find_element(:css, 'h4.subtitle').text.include?'swipe it, flip it, share it'
    end

    def test_home_find_restaurant
      @driver.navigate.to(@rootURL)
      verify_visible_image_in_css(:css, 'section.homeMap')
      assert @driver.find_element(:css, 'div.swatch h4.title').text.include?'find a restaurant'
    end

    def test_home_our_story
      @driver.navigate.to(@rootURL)
      verify_visible_image_in_css(:css, 'section.ourStory')
      assert @driver.find_element(:css, 'section.ourStory h3.title').text.include?'SINCE 1954'
      assert_not_nil @driver.find_element(:css, 'section.ourStory h4.subtitle').text
    end

    def test_home_made_to_order
      @driver.navigate.to(@rootURL)
      verify_visible_image_in_css(:css, 'section.madeToOrder')
      assert @driver.find_element(:css, 'section.madeToOrder h3.title').text.include?'MADE TO ORDER'
      assert_not_nil @driver.find_element(:css, 'section.madeToOrder h4.subtitle').text
    end

    # def test_home_bk_delivers
    #   verify_visible_image_in_css(:css, '.bkDelivers')
    #   assert @driver.find_element(:css, 'section.bkDelivers h3.title').text.include?'delivers'
    #   assert_not_nil @driver.find_element(:css, 'section.bkDelivers h4.subtitle').text
    # end

    def test_home_bk_app
      @driver.navigate.to(@rootURL)
      verify_visible_image_in_css(:css, '.bkDelivers')
      just_verify {assert @driver.find_element(:css, 'section.bkDelivers h3.title').text.include?'APP'}
      just_verify {assert_not_nil @driver.find_element(:css, 'section.bkDelivers h4.subtitle').text}
    end

    def test_home_bk_callouts
      @driver.navigate.to(@rootURL)
      #verify_visible_image_in_css(:css, '.bkCallouts')
      just_verify {assert_equal(4, how_many_rows(:css, 'section.bkCallouts .row .col-sm-3'))}
      @driver.find_elements(:css, 'section.bkCallouts .row .col-sm-3').each do |c|
        just_verify {assert_not_nil c.text}
      end
    end

    def how_many_rows(how, what)
      rowList = @driver.find_elements(how, what)
      rowList.size()
    end

    def just_verify(&blk)
      yield
    rescue Test::Unit::AssertionFailedError, Minitest::Assertion => ex
      #@verification_errors << ex
      p ex
    end

  end
end