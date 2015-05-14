require 'test/unit'
require 'selenium-webdriver'

class TestAddContact < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @base_url = 'https://216.46.31.242/Nexa/login.html'
    @driver.manage.timeouts.implicit_wait = 20
    @wait = Selenium::WebDriver::Wait.new :timeout => 30
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit()
  end

  def test_new_contact_DLC
    # To change this template use File | Settings | File Templates.
    @driver.navigate.to(@base_url)

    login()
    @driver.find_element(:link_text, 'Contacts').click
    @driver.find_element(:link_text, 'Add a New Contact').click

    (1..165).each_with_index do |x, index|

      # first name
      @driver.find_element(:id, 'contact.firstName').send_keys 'qa_firstn_script' + index.to_s

      # last name
      @driver.find_element(:css, '#generalTabPanel > div:nth-child(1) > div:nth-child(1) > table > tbody > tr:nth-child(3) > td.valueLabel > input[type="text"]').send_keys 'qa_lastncript' + index.to_s

      # email
      @driver.find_element(:css, '#generalTabPanel > div:nth-child(1) > div:nth-child(2) > table > tbody > tr:nth-child(2) > td.valueLabel > input[type="text"]').send_keys 'chk9imagine+' + index.to_s + '@gmail.com'

      # birthday
      @driver.find_element(:id, "stateVariables['contact.birthdate']").send_keys '08/25/2014'

      sleep 2

      @driver.find_element(:id, 'addContactButton').click
      sleep 3

      @driver.find_element(:link_text, 'Add a New Contact').click
      sleep 3

    end

  end

  def login
    @driver.find_element(:id, 'txtUsername').send_keys 'user'
    @driver.find_element(:id, 'txtPassword').send_keys 'password'
    @driver.find_element(:id, 'chkAgreeToTermsAndUse').click
    @driver.find_element(:xpath, '//*[@id="loginForm"]/table/tbody/tr[5]/td[2]/input').click
  end
end