require 'test/unit'
require 'selenium-webdriver'
require 'csv'

class ImportUser < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new :timeout => 120
    @baseURL = "http://bktesting.openface.com/Login.aspx"
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
  end

  def test_importUser
    @driver.get(@baseURL)
    admin_login()
    @driver.find_element(:id, "ctl00__navMenu_ctl04_HyperLink1").click
    @driver.find_element(:id, "ctl00_pageContentPlace__manageUsersLink").click

    data_import = csv_import
    data_import.each_with_index do |each_data, index|
      username = each_data['USERNAME']
      @driver.find_element(:css, '#ctl00__pageActionMenuPanel > table > tbody > tr > td:nth-child(3) > div > table > tbody > tr > td:nth-child(1) > input[type="text"]').send_keys username
      @driver.find_element(:id, "ctl00_Go").click
      sleep 1
      begin
        getFirstUsername = @driver.find_element(:css, '#ctl00_pageContentPlace__usersGrid_ctl01 > tbody > tr:nth-child(1)').text
      rescue Selenium::WebDriver::Error::NoSuchElementError
        puts "No element found for this username #{username}"
        next
      end
      sleep 1
      getUsername = getFirstUsername.split(' ')
      if getUsername[0] == username
        puts "#{index}, -- , #{getUsername[0]} is matched"
      else
        puts "#{index}, -- , #{getUsername[0]} is not matched #{username}"
      end
      @driver.find_element(:css, '#ctl00__pageActionMenuPanel > table > tbody > tr > td:nth-child(3) > div > table > tbody > tr > td:nth-child(1) > input[type="text"]').clear
    end

  end

  def admin_login
    @driver.find_element(:id, "ctl00_pageContentPlace__usernameBox").send_keys 'ofsupport'
    @driver.find_element(:id, "ctl00_pageContentPlace__passwordBox").send_keys '0p3nf4c3'
    @driver.find_element(:id, "ctl00_pageContentPlace__loginBtn").click
  end

  def csv_import
    csv = CSV.read('c:/turkey.csv', :headers => true)
  end
end