require 'test/unit'
require 'selenium-webdriver'

class MyTestLiveSite < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 10
    @verification_errors = []
    @baseURL = 'http://http://qa.reversecode.com:3333/index.html'
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    @driver.quit()
  end

  # # Fake test
  # def test_fail
  #
  #   fail('Not implemented')
  # end

  def test_LiveSite

  end
end