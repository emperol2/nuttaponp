require 'selenium-webdriver'
require 'test/unit'
require 'phantomjs'
require 'net/https'

class BKLib < Test::Unit::TestCase

  def initialize
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 6000
    @driver = Selenium::WebDriver.for :ff, :http_client => client
    @driver.manage.timeouts.implicit_wait = 60
    @wait = Selenium::WebDriver::Wait.new :timeout => 6000
  end

  def driver
    @driver
  end

  def wait
    @wait
  end

  def select_country(country, where)
    if country == 'UK' && where == 'QA'
      return 'http://origin:openface!@qa.burgerking.co.uk/'
    elsif country == 'UK' && where == 'STG'
      return 'http://bk-uk.openface.ca/'
    elsif country == 'US' && where == 'QA'
      return 'http://origin:openface!@originqa.bk.com/'
    elsif country == 'US' && where == 'PROD'
      return 'http://www.bk.com/'
    elsif country == 'CA' && where == 'PROD'
      return 'http://burgerking.ca/'
    end
  end

  def node_URL(country, where)
    if country == 'UK' && where == 'QA'
      return 'http://qa.burgerking.co.uk/node/'
    elsif country == 'UK' && where == 'STG'
      return 'http://bk-uk.openface.ca/node/'
    elsif country == 'US' && where == 'QA'
      return 'http://originqa.bk.com/node/'
    elsif country == 'US' && where == 'PROD'
      return 'http://www.bk.com/node/'
    elsif country == 'CA' && where == 'PROD'
      return 'http://burgerking.ca/node/'
    end
  end

end