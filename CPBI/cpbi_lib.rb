require 'selenium-webdriver'
require 'rubygems'

class CPBI_backend
  # To change this template use File | Settings | File Templates.
  def initialize
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 15
    @wait = Selenium::WebDriver::Wait.new :timeout => 60
  end

  def driver
    @driver

  end

  def wait
    @wait
  end

  def quit
    @driver.quit()
  end

  def login_backend
    @driver.get('http://icra-dev.openface.com/Composite/top.aspx')
    @wait.until {@driver.find_element(:css => 'input[name="username"]')}
    @driver.find_element(:css => 'input[name="username"]').send_key('ofsupport')
    @driver.find_element(:css => 'input[name="password"]').send_key('0p3nf4c3')
    @driver.find_element(:css => 'input[name="password"]').send_keys :return
  end

  def select_iframeid
    storeHtmlSource = @driver.page_source
    storeHtmlSource2 = storeHtmlSource.gsub(/frameborder="0" /, '')
    index = storeHtmlSource2.to_s.match(/iframe id="[a-z]+[0-9]+"/)
    @iframe = index[0].match(/[a-z]+[0-9]+/)
  end

end