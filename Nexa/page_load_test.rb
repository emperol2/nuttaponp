require 'test/unit'
require 'minitest/unit'
require 'selenium-webdriver'
require 'date'
require_relative '../Nexa/nexa_utilities'

class PageLoadTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 20
    @wait = Selenium::WebDriver::Wait.new :timeout => 30
    @Nexa_Util = NexaUtilities.new
    @verification_errors = []
    #@baseURL = 'https://216.46.31.242/Nexa/login.html'
    @baseURL = 'http://nexa.incontact.ca/Nexa/login.html'
    @sitePerformance = File.new('C:\Users\nuttapon\Documents\Nexa\SitePerformance.txt', 'a')
    @sitePerformance.puts "\n\nToday is: #{DateTime.now.to_s}"
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
    @sitePerformance.close
  end

  # Fake test
  # def test_fail
  #
  #   fail('Not implemented')
  # end

  # 1 minute
  def test_MortgagesClosing_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at All Contacts
    @driver.find_element(:link_text, 'Mortgages Closing Next 2 Months').click
    start = Time.now
    @wait.until { @driver.find_element(:class, 'resultTable') }
    stop = Time.now
    @sitePerformance.puts "Page load time 'Mortgages Closing Next 2 Months': #{@Nexa_Util.time_diff_milli(start, stop)}"
    assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(start, stop)
  end


  # 13 seconds
  def test_Birthday_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at All Contacts
    @driver.find_element(:link_text, 'Birthdays Next 2 Months').click
    start = Time.now
    @wait.until { @driver.find_element(:class, 'resultTable') }
    stop = Time.now
    @sitePerformance.puts "Page load time 'Birthdays Next 2 Months': #{@Nexa_Util.time_diff_milli(start, stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(start, stop)
  end


  # 2 minutes, 33 seconds
  def test_PreApproval_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at All Contacts
    @driver.find_element(:link_text, 'Pre-Approvals Expiring 2 Months').click
    start = Time.now
    @wait.until { @driver.find_element(:class, 'resultTable') }
    stop = Time.now
    @sitePerformance.puts "Page load time 'Pre-Approvals Expiring 2 Months': #{@Nexa_Util.time_diff_milli(start, stop)}"
    assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(start, stop)
  end


  # 8 seconds
  def test_allContactWithEmail_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at All Contacts with Email
    @driver.find_element(:link_text, 'All Contacts with Email').click
    start = Time.now
    @wait.until { @driver.find_element(:class, 'resultTable') }
    stop = Time.now
    @sitePerformance.puts "Page load time 'All Contacts with Email': #{@Nexa_Util.time_diff_milli(start, stop)}"
    assert_operator 10000.00, :>, @Nexa_Util.time_diff_milli(start, stop)
  end


  # 8 seconds
  def test_allContactWithoutEmail_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at All Contacts without Email
    @driver.find_element(:link_text, 'All Contacts without Email').click
    start = Time.now
    @wait.until { @driver.find_element(:class, 'resultTable') }
    stop = Time.now
    @sitePerformance.puts "Page load time 'All Contacts without Email': #{@Nexa_Util.time_diff_milli(start, stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(start, stop)
  end

  # 1 minute, 2 seconds
  def test_allContact_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at All Contacts
    @driver.find_element(:link_text, 'All Contacts').click
    start = Time.now
    @wait.until { @driver.find_element(:class, 'resultTable') }
    stop = Time.now
    #p "Page load time 'All Contacts': #{time_diff_milli(start, stop)}"
    @sitePerformance.puts "Page load time 'All Contacts': #{@Nexa_Util.time_diff_milli(start, stop)}"
    assert_operator 62000.00, :>, @Nexa_Util.time_diff_milli(start, stop)
  end

  # All application - 60 seconds
  def test_allApplication_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    @driver.find_element(:link_text, 'All Applications').click
    start = Time.now
    @wait.until { @driver.find_element(:class, 'resultTable') }
    stop = Time.now
    @sitePerformance.puts "Page load time 'All Applications': #{@Nexa_Util.time_diff_milli(start, stop)}"
    assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(start, stop)
  end


  # Test Search Contact - 15 seconds
  def test_find_contact_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at Contacts link Top Nav
    @driver.find_element(:link_text, 'Contacts').click
    @driver.find_element(:css, '#simpleSearchContactForm > table > tbody > tr:nth-child(3) > td.valueLabel > input[type="text"]').send_keys 'Lisa'
    @driver.find_element(:css, '#simpleSearchContactForm > table > tbody > tr:nth-child(12) > td:nth-child(2) > table > tbody > tr > td.textButton2014').click
    start = Time.now
    @wait.until { @driver.find_element(:class, 'standardTable') }
    stop = Time.now
    @sitePerformance.puts "Page load time 'Find Contacts': #{@Nexa_Util.time_diff_milli(start, stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(start, stop)
  end


  # Test Search Application - 15 seconds
  def test_find_application_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at Contacts link Top Nav
    @driver.find_element(:link_text, 'Applications').click
    @driver.find_element(:css, '#simpleSearchApplicationForm > table > tbody > tr:nth-child(2) > td.valueLabel > input[type="text"]').send_keys 'Lisa'
    @driver.find_element(:css, '#simpleSearchApplicationForm > table > tbody > tr:nth-child(8) > td:nth-child(2) > table > tbody > tr > td.textButton2014').click
    start = Time.now
    @wait.until { @driver.find_element(:class, 'standardTable') }
    stop = Time.now
    @sitePerformance.puts "Page load time 'Find Applications': #{@Nexa_Util.time_diff_milli(start, stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(start, stop)
  end



end