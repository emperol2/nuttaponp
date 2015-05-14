require 'selenium-webdriver'
require 'test/unit'
#require 'phantomjs'
require_relative 'utility.rb'

module Test
  class TestItemsPage < Test::Unit::TestCase



    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @driver.navigate.to('http://www.bk.com/menu')
      @driver.manage.timeouts.implicit_wait = 50
      @driver.manage.timeouts.script_timeout = 20
      @wait = Selenium::WebDriver::Wait.new :timeout => 10
      #@utility = Utilities.new
    end

    def teardown
      @driver.quit
    end

    def test_visible_image_menu
      imgList = @driver.find_elements(:tag_name, 'img')
      imgList.each do |i|
        #puts i.attribute('src')
        res = Net::HTTP.get_response(URI(i.attribute('src')))
        assert_equal('200', res.code, "This is error #{i.attribute('src')}")
      end
      #@utility.myfuntion
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

    def test_visible_image_items
      ary = Array.new
      itemsArray = Array.new
      nodeURL = 'http://www.bk.com/node/'

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

      itemsArray.each do |a|
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
          if i.attribute('src').include?('square_thumbnail') == false && i.attribute('typeof') != nil
            res = Net::HTTP.get_response(URI(i.attribute('src')))
            assert_equal('200', res.code, "This is error #{i.attribute('src')}")
          end
        end
      end

    end

    def test_nutrition_table
      ary = Array.new
      itemsArray = Array.new
      nodeURL = 'http://www.bk.com/node/'

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

      itemsArray.each do |a|
        @driver.navigate.to(a)
        p a
        begin
          @wait.until {@driver.find_element(:css, 'li.calories .number').displayed?}
          nutritionalList = @driver.find_elements(:css, 'li.calories .number')
          #p nutritionalList[0].text
          if nutritionalList[0].text.empty?
            p "error #{a}"
          end
            #assert_not_empty(nutritionalList[0].text)
        rescue Selenium::WebDriver::Error::TimeOutError
          p "Error #{a}"
          next
        end


      end

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
          p "URL Error: #{i.attribute('innerHTML')}"
          next
        end

      end
      ary.uniq.each do |a|
        #puts a
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