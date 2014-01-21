require 'test/unit'
require 'rubygems'
require 'selenium-webdriver'
require 'watir-webdriver'
#require 'minitest/autorun'
require_relative 'test_helper.rb'

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @base_url = 'http://qa.cpbi-icra.ca/Composite/top.aspx'
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 20
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
  end

  # Fake test
  def test_fail
    # To change this template use File | Settings | File Templates.
    #fail('Not implemented')
    skip "test skip"
    @driver.get(@base_url)
    @driver.find_element(:css => 'input[name="username"]').send_key('ofsupport')
    @driver.find_element(:css => 'input[name="password"]').send_key('0p3nf4c3')
    @driver.find_element(:css => 'input[name="password"]').send_key('\13')
  end

  def test_upload
    skip "test skip"
    @driver.get('http://jasny.github.io/bootstrap/javascript/')
    @driver.find_element(:css => 'div.fileinput').send_keys('C:\\test.xls')
    sleep 5000
  end

end