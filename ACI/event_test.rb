require 'test/unit'
require 'selenium-webdriver'

class EventTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 10
    @verification_errors = []
    @baseURL = 'http://www.aci-africa.aero/'
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
  end

  def test_event
    @driver.get(@baseURL)
    assert @driver.title.include?('aci')
    @events = @driver.find_element(:link, 'Events').click
    @wait.until { @driver.find_element(:css, 'div.Events') }

    assert isElementPresent?(:css, 'div.EventCalendar-Calendar')
    @calendar_element = @driver.find_element(:css, 'div.EventCalendar-Calendar').displayed?
    puts @driver.title

    # Select events year = 2013
    @select_events_year = @driver.find_element(:link, '2013').click
    @wait.until { @driver.find_element(:css, 'div.EventCalendar-Calendar') }

    # Select events month = Next month(2013 February)
    @select_event_NextMonth = @driver.find_element(:xpath, '//a[3]/span').click
    @wait.until { @driver.find_element(:css, 'div.EventCalendar-Calendar') }
    puts @driver.current_url

    begin
      @found = @driver.find_element(:css => 'div.title')
      # Check title of Event on Events page.
      if @found
        #true # return true if this element is found
        @feb_event_name = @driver.find_element(:css, 'div.title').text
        assert @driver.find_element(:css => 'div.title')
        puts @feb_event_name
      else
        #false # return false if this element is not found
        puts 'No Events'
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError # catch if NoSuchElementError appears
      #false
      @no_event = @driver.find_element(:css, 'div.EventCalendar p').text
      assert isElementPresent?(:css, 'div.title')
      puts @no_event
    end
  end

  def isElementPresent?(type, selector)
    begin
      @driver.find_element(type, selector)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
    end
  end
end