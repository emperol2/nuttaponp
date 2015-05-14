# UTF-8
require 'selenium-webdriver'
require 'test/unit'
require 'phantomjs'
#require_relative 'utility.rb'

module Test
  class GetIngredient < Test::Unit::TestCase

    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @driver.navigate.to('http://of-qa.bk.ca:3333/fr/menu/breakfast')
      @driver.manage.timeouts.implicit_wait = 50
      @driver.manage.timeouts.script_timeout = 20
      @wait = Selenium::WebDriver::Wait.new :timeout => 10
      #@utility = Utilities.new
    end

    def teardown
      @driver.quit
    end

    def test_nutrition_table
      # ary = Array.new
       itemsArray = Array.new
       nodeURL = 'http://of-qa.bk.ca:3333/node/'
      #
      # cagetoryList = @driver.find_elements(:css, '.food-category a')
      # cagetoryList.each do |c|
      #   ary.push(c.attribute('href'))
      # end

      #ary.each do |aa|
        @driver.navigate.to('http://of-qa.bk.ca:3333/fr/menu/kids-meals')
        findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
        findItemLinks.each do |f|
          #p f.attribute('data-product-id')
          itemsArray.push(nodeURL+f.attribute('data-product-id'))
          #p itemsArray.size()
        end
      #end

      itemsArray.each do |a|
        @driver.navigate.to(a)
        p a
        p @driver.find_element(:css, 'h1').text
        begin
          @wait.until {@driver.find_element(:css, 'label span').displayed?}
          nutritionalList = @driver.find_elements(:css, 'label span')
          #p nutritionalList[0].text
          if nutritionalList[0].text.empty?
            p "error #{a}"
          else
            nutritionalList.each do |n|

              p n.text
            end
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



  end
end