require 'test/unit'
require 'selenium-webdriver'
require 'rubygems'

class Events < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @base_url = "http://icra-dev/"
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 20
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.close
  end

  # Fake test
  def test_event_not_login

    # To change this template use File | Settings | File Templates.
    #fail('Not implemented')
    @driver.get(@base_url)
    @driver.find_element(:css => 'div#logo').click
    @driver.find_element(:css => 'li.darkblue a').click
    @driver.find_element(:css => 'li.darkblue div.landing-menu a').click
    page_header = @driver.find_element(:css => 'div.page-header').text
    assert_equal(page_header.slice("ALL UPCOMING EVENTS"), "ALL UPCOMING EVENTS")


  end
end