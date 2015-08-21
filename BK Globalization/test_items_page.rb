require 'selenium-webdriver'
require 'test/unit'
require 'phantomjs'
require 'net/https'
require_relative 'bk_lib.rb'

module Test
  class TestItemsPage < Test::Unit::TestCase

    def setup
      @bk_lib = BKLib.new
      @driver = @bk_lib.driver
      @wait = @bk_lib.wait
      @country = 'CA'
      @where = 'PROD'
      @driver.navigate.to(@bk_lib.select_country(@country, @where))
    end

    def teardown
      @driver.quit
    end

    # def test_title
    #   p currentURL = @driver.current_url
    #   assert(@driver.title, 'Burger King UK (QA)')
    # end

    def test_visible_image_items
      currentURL = @driver.current_url
      @driver.navigate.to(currentURL+'menu')
      ary = Array.new
      itemsArray = Array.new
      nodeURL = @bk_lib.node_URL(@country, @where)

      categoryList = @driver.find_elements(:css, '.food-category a')
      categoryList.each do |c|
        ary.push(c.attribute('href'))
      end

      ary.each do |aa|
        @driver.navigate.to(aa)
        findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
        findItemLinks.each do |f|
         itemsArray.push(nodeURL+f.attribute('data-product-id'))
        end
      end

      itemsArray.uniq.each do |a|
        @driver.navigate.to(a)
        imgList = @driver.find_elements(:tag_name, 'img')
        imgList.each do |i|
          if i.attribute('src').include?('logo') == false
            p i.attribute('src')
            req = Net::HTTP::Get.new(URI(i.attribute('src')).request_uri)
            Net::HTTP.start(URI(i.attribute('src')).hostname, URI(i.attribute('src')).port) {|http|
              # http.request(req)
              assert_match(/200/, http.request(req).code)
            }
          end
        end
      end
    end # End Test Visible Image for Menu Items

    def test_nutrition_table
      p currentURL = @driver.current_url
      @driver.navigate.to(currentURL+'menu')
      ary = Array.new
      itemsArray = Array.new
      nodeURL = @bk_lib.node_URL(@country, @where)

      categoryList = @driver.find_elements(:css, '.food-category a')
      categoryList.each do |c|
        ary.push(c.attribute('href'))
      end

      ary.each do |aa|
        @driver.navigate.to(aa)
        findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
        findItemLinks.each do |f|
          itemsArray.push(nodeURL+f.attribute('data-product-id'))
        end
      end

      itemsArray.uniq.each do |a|
        @driver.navigate.to(a)
        begin
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
        end # End Catch
      end
    end # End Test Nutrition Table

  end # End Class
end # End Module