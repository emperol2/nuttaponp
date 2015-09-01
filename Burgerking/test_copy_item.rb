require 'selenium-webdriver'
require 'test/unit'
require 'minitest'
require 'phantomjs'
require_relative 'bk_lib'

include BK_lib

module Test
  class TestItemsPage < Test::Unit::TestCase

    def setup
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 300
      @driver = Selenium::WebDriver.for :phantomjs, :http_client => client
      @rootURL = SITE_URL
      #@driver.navigate.to('http://originstg.bk.com/menu')
      @driver.manage.timeouts.implicit_wait = 60
      @driver.manage.timeouts.script_timeout = 30
      @wait = Selenium::WebDriver::Wait.new :timeout => 25
    end

    def teardown
      @driver.quit
    end

    def test_visible_image_items
      # @driver.navigate.to("#{@rootURL}/menu")
      # ary = Array.new
      # itemsArray = Array.new
      # nodeURL = "#{@rootURL}/node/"
      # #nodeURL = 'http://originstg.bk.com/node/'
      #
      # cagetoryList = @driver.find_elements(:css, '.food-category a')
      # cagetoryList.each do |c|
      #   ary.push(c.attribute('href'))
      #   #p c.attribute('href')
      # end
      #
      # ary.each do |aa|
      #   @driver.navigate.to(aa)
      #   findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
      #   findItemLinks.each do |f|
      #     f.attribute('data-product-id')
      #     itemsArray.push(nodeURL+f.attribute('data-product-id'))
      #     # itemsArray.size()
      #   end
      # end
      #
      # itemsArray.uniq.each do |a|
      @driver.navigate.to('http://www.burgerking.co.uk/menu-item/long-cheeseburger-0')
      #p a
      # imgList = @driver.find_elements(:tag_name, 'img')
      # imgList.each do |i|
      #   #puts i.attribute('src')
      #   # if i.attribute('typeof') != nil
      #   #   p i.attribute('src')
      #   #   res = Net::HTTP.get_response(URI(i.attribute('src')))
      #   #   assert_equal('200', res.code, "This is error #{i.attribute('src')}")
      #   # end
      #   p i.attribute('src')
      #   res = Net::HTTP.get_response(URI(i.attribute('src')))
      #   verify_test { assert_equal('200', res.code, "This is error #{i.attribute('src')}") }
      #   # if i.attribute('src').include?('square_thumbnail') == false && i.attribute('typeof') != nil
      #   #   p i.attribute('src')
      #   #   res = Net::HTTP.get_response(URI(i.attribute('src')))
      #   #   assert_equal('200', res.code, "This is error #{i.attribute('src')}")
      #   # end
      # end
      visible_image?
    end

    def test_xxx
      sharedModule
    end

    def test_product_search_found
      @driver.navigate.to("#{@rootURL}/search")
      @driver.find_element(:css, '.contactInput').send_keys(PRODUCT_SEARCH_TRUE)
      @driver.find_element(:css, '#search-api-page-search-form > div > div > button').click
      sleep 2
      just_verify {assert @driver.title.include?('Search')}
      resultList = @driver.find_elements(:css, '.itemsList li')
      resultList.each do |r|
        htmlResults = r.attribute('innerHTML')
        assert((htmlResults.match /#{PRODUCT_SEARCH_TRUE}/i), "The result in the table should contain 'burger'")
      end
      resultsText = @driver.find_element(:css, 'div.resultsNo').text
      resultsSplit = resultsText.split(/[a-zA-Z ]/)
      getResultNumber = resultsSplit[12]
      assert(getResultNumber.to_i > 0, 'Search result number should greater than 0')
    end

    def test_product_search_not_found
      @driver.navigate.to("#{@rootURL}/search")
      @driver.find_element(:css, '.contactInput').send_keys(PRODUCT_SEARCH_FALSE)
      @driver.find_element(:css, '#search-api-page-search-form > div > div > button').click
      sleep 2
      just_verify {assert(@driver.title.include?('Search'))}
      assert((element_present?(:css, '.itemsList li') == false), 'Page title is incorrect')
      assert((@driver.find_element(:css, 'h3.sectionTitle').text.match /#{PRODUCT_SEARCH_FALSE}/i), 'Title tag is incorrect')
      assert((@driver.find_element(:css, 'div.resultsNo').text.match /No/i), 'Search result number is incorrect')
    end

    def test_home_bk_app
      @driver.navigate.to(@rootURL)
      verify_visible_image_in_css(:css, '.bkDelivers')
      just_verify {assert @driver.find_element(:css, 'section.bkDelivers h3.title').text.include?'APP'}
      just_verify {assert_not_nil @driver.find_element(:css, 'section.bkDelivers h4.subtitle').text}
    end


    def test_visible_image_youmayalsolike
      @driver.navigate.to("#{@rootURL}/menu")
      ary = Array.new
      itemsArray = Array.new
      nodeURL = "#{@rootURL}/node/"
      #nodeURL = 'http://originstg.bk.com/node/'

      cagetoryList = @driver.find_elements(:css, '.food-category a')
      cagetoryList.each do |c|
        ary.push(c.attribute('href'))
      end

      ary.each do |aa|
        @driver.navigate.to(aa)
        findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
        findItemLinks.each do |f|
          #p f.attribute('data-product-id')
          itemsArray.push(nodeURL+f.attribute('data-product-id'))
          #p itemsArray.size()
        end
      end

      itemsArray.uniq.each do |a|
        @driver.navigate.to(a)
        #p a
        imgList = @driver.find_elements(:tag_name, 'img')
        imgList.each do |i|
          #puts i.attribute('src')
          # if i.attribute('typeof') != nil
          #   p i.attribute('src')
          #   res = Net::HTTP.get_response(URI(i.attribute('src')))
          #   assert_equal('200', res.code, "This is error #{i.attribute('src')}")
          # end
          if i.attribute('src').include?('square_thumbnail') == true
            p i.attribute('src')
            res = Net::HTTP.get_response(URI(i.attribute('src')))
            assert_equal('200', res.code, "This is error #{i.attribute('src')}")
          end
        end
      end

    end


    def test_nutrition_table
      @driver.navigate.to("#{@rootURL}/menu")
      ary = Array.new
      itemsArray = Array.new
      nodeURL = "#{@rootURL}/node/"
      #nodeURL = 'http://originstg.bk.com/node/'

      cagetoryList = @driver.find_elements(:css, '.food-category a')
      cagetoryList.each do |c|
        ary.push(c.attribute('href'))
      end

      ary.each do |aa|
        @driver.navigate.to(aa)
        findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
        findItemLinks.each do |f|
          #p f.attribute('data-product-id')
          itemsArray.push(nodeURL+f.attribute('data-product-id'))
          #p itemsArray.size()
        end
      end

      itemsArray.uniq.each do |a|
        @driver.navigate.to(a)
        #p a
        begin
          sleep 2
          @wait.until {@driver.find_element(:css, 'li.calories .number').displayed?}
          nutritionalList = @driver.find_elements(:css, 'li.calories .number')
          #p nutritionalList[0].text
          if nutritionalList[0].text.empty?
            p "No Table #{a}"
          end
            #assert_not_empty(nutritionalList[0].text)
        rescue Selenium::WebDriver::Error::TimeOutError
          p "TimeOutError #{a}"
          next
        end


      end

    end

    def visible_image?
      imgListHero = @driver.find_elements(:css, '.hero img')
      imgListYMAL = @driver.find_elements(:css, '.recommendations img')
      allImgList = imgListHero + imgListYMAL
      if imgListHero.size() > 1 or imgListYMAL.size() > 2
        allImgList.each do |i|
          begin
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
              #puts res.code
              assert res.code.include?'200'
            end
          rescue NoMethodError => e
            p "Error Exception: #{i.attribute('src')}"
            p e
            next
          end
        end
      else
        false
        p "Warning: Please check this URL #{@driver.current_url}"
      end
    end

    def verify_test(&blk)
      yield
    rescue MiniTest::Assertion => ex
      @verification_errors << ex
    end




  end
end