require 'test/unit'
require 'selenium-webdriver'
require_relative 'login_page.rb'

class MyTestPageObject < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @login_page = LoginPage.new(@driver)
    @baseURL = 'http://qa.healthnow.com'
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
  end

  def test_Profile
    @driver.get(@baseURL)
    @login_page.username = 'somsri'
    @login_page.password = 'pattana1'
    @login_page.login

  end

end