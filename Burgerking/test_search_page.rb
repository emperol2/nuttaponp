# UTF-8
require 'test/unit'
require 'rubygems'
require 'selenium-webdriver'


module Test
  class TestSearchPage < Test::Unit::TestCase

    # Called before every test method runs. Can be used
    # to set up fixture information.
    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @driver.navigate.to('http://www.bk.com/search')
      @driver.manage.timeouts.implicit_wait = 40
      @wait = Selenium::WebDriver::Wait.new :timeout => 20
    end

    # Called after every test method runs. Can be used to tear
    # down fixture information.

    def test_product_search_found
      @driver.find_element(:css, '#edit-term').send_keys('burger')
      @driver.find_element(:css, '#views-exposed-form-search-page button').click
      assert @driver.title.include?('search')
      resultList = @driver.find_elements(:css, '.itemsList li')
      resultList.each do |r|
        htmlResults = r.attribute('innerHTML')
        assert((htmlResults.match /burger/i), "The result in the table should contain 'burger'")
      end
      resultsText = @driver.find_element(:css, 'div.resultsNo').text
      resultsSplit = resultsText.split(/[a-zA-Z ]/)
      getResultNumber = resultsSplit[0]
      assert(getResultNumber.to_i > 0, 'Search result number should greater than 0')
    end

    def test_product_search_not_found
      @driver.find_element(:css, '#edit-term').send_keys('not found')
      @driver.find_element(:css, '#views-exposed-form-search-page button').click
      assert(@driver.title.include?('search'))
      assert((element_present?(:css, '.itemsList li') == false), 'Page title is incorrect')
      assert((@driver.find_element(:css, 'h3.sectionTitle').text.match /not found/i), 'Title tag is incorrect')
      assert((@driver.find_element(:css, 'div.resultsNo').text.match /no/i), 'Search result number is incorrect')
    end

    # def find_menu_top_nav(where)
    #   topNavLists = @driver.find_elements(:css, '.menuItem-medium')
    #   topNavLists.each do |t|
    #     if t.text.include?where
    #       t
    #     end
    #   end
    # end

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

    def teardown
      # Do nothing
      @driver.quit
    end

  end
end