require 'test/unit'
require 'selenium-webdriver'

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @base_url = 'http://com.sx.com'
    @driver.manage.timeouts.implicit_wait = 10
    # Wait for browser timeout 20 minutes
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

    @driver.get(@base_url)

    # Invalid username and password
    @driver.find_element(:css => 'a[href="#"]').click
    @driver.find_element(:id => 'mini-login')
    @driver.execute_script("document.getElementById('mini-login').value = 'xxx@gmail.com';");
    #puts "found element #{test}"
    @driver.find_element(:id => 'mini-password')
    @driver.execute_script("document.getElementById('mini-password').focus(); document.getElementById('mini-password').value = '11111111';");
    #@password = @driver.find_element(:name => 'login[password]')
    #@password.send_keys '11111111'
    @button = @driver.find_element(:name => 'sign in')
    #puts @button
    @button.submit

    # try to put the wrong username, correct password

    @error_message = @driver.find_element(:xpath => '//*[@id="main"]/div/div/ul/li/ul/li/span').text
    string = 'Invalid login or password.'
    assert_equal(@error_message, string.encode('UTF-8'))
    puts 'Invalid login or password.'

    # Valid username and password
    @driver.navigate.to(@base_url)
    @driver.find_element(:css => 'a[href="#"]').click
    @driver.execute_script("document.getElementById('mini-login').value = 'emperol2@gmail.com';");
    @driver.execute_script("document.getElementById('mini-password').focus(); document.getElementById('mini-password').value = '111111';");
    @button = @driver.find_element(:name => 'sign in')
    @button.submit

    checkLogout = @driver.find_element(:xpath => '//*[@id="header"]/div[3]/div/ul[1]/li[2]/a').text
    textLogout = 'MY ACCOUNT'
    assert_equal(checkLogout, textLogout.encode('UTF-8'))
    puts 'Valid username and password'

  end

end