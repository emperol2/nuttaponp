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
    @driver.manage.timeouts.implicit_wait = 50
    @wait = Selenium::WebDriver::Wait.new :timeout => 270
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

  # def test_MortgagesClosing_load
  #   @driver.get(@baseURL)
  #   @Nexa_Util.loginAsNormalUser(@driver)
  #   waitForPageFullyLoaded(20);
  #   @start = Time.now
  #
  #   begin
  #     # Click at All Contacts
  #     @driver.find_element(:link_text, 'Mortgages Closing Next 2 Months').click
  #     @wait.until { @driver.find_element(:class, 'resultTable') }
  #
  #   rescue Timeout::Error
  #     # waitForPageFullyLoaded(60);
  #     waitForPageFullyLoaded(60);
  #     @stop = Time.now
  #     @sitePerformance.puts "Page load time 'Mortgages Closing Next 2 Months': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
  #     assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  #   end
  #
  # end

  # 1 minute
  def test_MortgagesClosing_load
    @driver.get(@baseURL)

    #begin
    @Nexa_Util.loginAsNormalUser(@driver)
    #@wait.until { @driver.find_element(:id, 'leftNavigationContent') }

    #rescue Timeout::Error

    waitForPageFullyLoaded(20);
    @start = Time.now

    # begin
    # Click at All Contacts
    @driver.find_element(:link_text, 'Mortgages Closing Next 2 Months').click
    # @wait.until { @driver.find_element(:class, 'resultTable') }

    # rescue Timeout::Error
    # waitForPageFullyLoaded(60);
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Mortgages Closing Next 2 Months': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
    # end
    #end

  end


  # 13 seconds
  def test_Birthday_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    waitForPageFullyLoaded(20);
    @start = Time.now

    # Click at All Contacts
    @driver.find_element(:link_text, 'Birthdays Next 2 Months').click
    # @wait.until { @driver.find_element(:class, 'resultTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Birthdays Next 2 Months': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  end


  # 2 minutes, 33 seconds
  def test_PreApproval_load
    @driver.get(@baseURL)
    #begin
    @Nexa_Util.loginAsNormalUser(@driver)
    #  @wait.until { @driver.find_element(:id, 'leftNavigationContent') }

    # rescue Timeout::Error
    waitForPageFullyLoaded(60);
    @start = Time.now

    # Click at All Contacts
    @driver.find_element(:link_text, 'Pre-Approvals Expiring 2 Months').click
    # @wait.until { @driver.find_element(:class, 'resultTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Pre-Approvals Expiring 2 Months': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
    # end
  end


  # 8 seconds
  def test_allContactWithEmail_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    waitForPageFullyLoaded(20);
    @start = Time.now
    # Click at All Contacts with Email
    @driver.find_element(:link_text, 'All Contacts with Email').click
    # @wait.until { @driver.find_element(:class, 'resultTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'All Contacts with Email': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 10000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  end


  # 8 seconds
  def test_allContactWithoutEmail_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    waitForPageFullyLoaded(20);
    @start = Time.now
    # Click at All Contacts without Email
    @driver.find_element(:link_text, 'All Contacts without Email').click
    # @wait.until { @driver.find_element(:class, 'resultTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'All Contacts without Email': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  end

  # 1 minute, 2 seconds
  def test_allContact_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    waitForPageFullyLoaded(20);
    @start = Time.now
    # Click at All Contacts
    @driver.find_element(:link_text, 'All Contacts').click
    # @wait.until { @driver.find_element(:class, 'resultTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    #p "Page load time 'All Contacts': #{time_diff_milli(@start, @stop)}"
    @sitePerformance.puts "Page load time 'All Contacts': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 62000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  end

  # All application - 60 seconds
  def test_allApplication_load
    @driver.get(@baseURL)
    #begin
    @Nexa_Util.loginAsNormalUser(@driver)
    # @wait.until { @driver.find_element(:id, 'leftNavigationContent') }

    # rescue Timeout::Error
    waitForPageFullyLoaded(40);
    @start = Time.now
    @driver.find_element(:link_text, 'All Applications').click
    # @wait.until { @driver.find_element(:class, 'resultTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'All Applications': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
    # end
  end

  def test_Variable_Rate_Clients_load
    @driver.get(@baseURL)
    # begin
    @Nexa_Util.loginAsNormalUser(@driver)
    # @wait.until { @driver.find_element(:id, 'leftNavigationContent') }

    # rescue Timeout::Error
    waitForPageFullyLoaded(60);
    @start = Time.now
    @driver.find_element(:link_text, 'Variable Rate Clients').click
    # @wait.until { @driver.find_element(:class, 'resultTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Variable Rate Clients': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
    #  end
  end

  # Mortgage Anniversaries 2 Months - 60 seconds
  def test_MortgageAniversary_load
    @driver.get(@baseURL)
    #begin
    @Nexa_Util.loginAsNormalUser(@driver)
    # @wait.until { @driver.find_element(:id, 'leftNavigationContent') }

    # rescue Timeout::Error

    waitForPageFullyLoaded(60);
    @start = Time.now
    @driver.find_element(:link_text, 'Mortgage Anniversaries 2 Months').click
    #@wait.until { @driver.find_element(:class, 'resultTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Mortgage Anniversaries 2 Months': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
    #end
  end

  # Mortgages Maturing 6 Months - 60 seconds
  def test_MortgageMaturing_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    waitForPageFullyLoaded(20);
    @start = Time.now
    @driver.find_element(:link_text, 'Mortgages Maturing 6 Months').click
    # @wait.until { @driver.find_element(:class, 'resultTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Mortgages Maturing 6 Months': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 60000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  end


  # Test Search Contact - 15 seconds
  def test_find_contact_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at Contacts link Top Nav
    @driver.find_element(:link_text, 'Contacts').click
    @driver.find_element(:css, '#simpleSearchContactForm > table > tbody > tr:nth-child(3) > td.valueLabel > input[type="text"]').send_keys 'Lisa'
    waitForPageFullyLoaded(20);
    @start = Time.now
    @driver.find_element(:css, '#simpleSearchContactForm > table > tbody > tr:nth-child(12) > td:nth-child(2) > table > tbody > tr > td.textButton2014').click
    # @wait.until { @driver.find_element(:class, 'standardTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Find Contacts': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  end


  # Test Search Application - 15 seconds
  def test_find_application_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # Click at Contacts link Top Nav
    @driver.find_element(:link_text, 'Applications').click
    @driver.find_element(:css, '#simpleSearchApplicationForm > table > tbody > tr:nth-child(2) > td.valueLabel > input[type="text"]').send_keys 'Lisa'
    waitForPageFullyLoaded(20);
    @start = Time.now
    @driver.find_element(:css, '#simpleSearchApplicationForm > table > tbody > tr:nth-child(8) > td:nth-child(2) > table > tbody > tr > td.textButton2014').click
    # @wait.until { @driver.find_element(:class, 'standardTable') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Find Applications': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  end

  # Test Marketing Plan - 15 seconds
  def test_Marketing_Plan_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    waitForPageFullyLoaded(20);
    @start = Time.now
    # Click at Marketing Plan link Top Nav
    @driver.find_element(:link_text, 'Marketing Plans').click
    # @wait.until { @driver.find_element(:css, '#viewMarketingPlansCommand > table') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Marketing Plan': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  end

  # Test Goals Manager - 15 seconds
  def test_Goals_Manager_load
    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    waitForPageFullyLoaded(20);
    @start = Time.now
    # Click at Goals Manager link Top Nav
    @driver.find_element(:link_text, 'Goals Manager').click
    #@wait.until { @driver.find_element(:class, 'tblDlcGoalsResult') }
    waitForPageFullyLoaded(20);
    @stop = Time.now
    @sitePerformance.puts "Page load time 'Goals Manager': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
    assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
  end

  def test_File_Status_load
    in_the_funnel = ['In Progress', 'Ready to Submit', 'Submitted', 'Approved', 'Accepted', 'Confirmed', 'Ready to Close']

    @driver.get(@baseURL)
    @Nexa_Util.loginAsNormalUser(@driver)
    # waitForPageFullyLoaded(20);
    in_the_funnel.each_with_index do |x, y|
      @start = Time.now
      # Click at Goals Manager link Top Nav
      @driver.find_element(:link_text, in_the_funnel[y]).click
      # @wait.until { @driver.find_element(:class, 'tblDlcGoalsResult') }
      waitForPageFullyLoaded(20);
      @stop = Time.now
      @sitePerformance.puts "Page load time '#{in_the_funnel[y]}': #{@Nexa_Util.time_diff_milli(@start, @stop)}"
      # assert_operator 15000.00, :>, @Nexa_Util.time_diff_milli(@start, @stop)
      @driver.get('https://nexa.incontact.ca/Nexa/index.html?_flowId=dlc-flow&_initialViewId=homeDlc')
    end

  end

  def waitForPageFullyLoaded(timeoutMs)
    previous = 0
    current = 0
    timeSliceMs = 1
    begin
      previous = current
      sleep(timeSliceMs)
      timeoutMs -= timeSliceMs;
      current = @driver.find_elements(:xpath, '//*').size();
    end until (current > previous && timeoutMs > 0)

    if(timeoutMs > 0)
      true
    else
      false
    end
  end

end