require 'test/unit'
require 'selenium-webdriver'
require 'rubygems'
require_relative 'cpbi_lib'

class Events < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @base_url = "http://qa.cpbi-icra.ca/"
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 20
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.close
  end

  # Fake test
  def test_event_not_login
    skip 'skip...'
    # To change this template use File | Settings | File Templates.
    #fail('Not implemented')
    @driver.get(@base_url)
    @driver.find_element(:css => 'div#logo').click
    @driver.find_element(:css => 'li.darkblue a').click
    @driver.find_element(:css => 'li.darkblue div.landing-menu a').click
    page_header = @driver.find_element(:css => 'div.page-header').text
    assert_equal(page_header.slice("ALL UPCOMING EVENTS"), "ALL UPCOMING EVENTS")


  end

  def test_function

    # To change this template use File | Settings | File Templates.
    #fail('Not implemented')
    @driver.get('http://qa.cpbi-icra.ca/Jobs/Submit-a-Job-Posting')
    x = @driver.find_element(:id => getAnyLocator('ctl00_ctl00_phContent_ctl13_ctlYourInformation_ctlAddressEditorVisitor_txtFirstName'))
    p x

    y = @driver.find_element(:id => getAnyLocator('ctl00_ctl00_phContent_ctl13_ctlYourInformation_ctlAddressEditorVisitor_txtPhone'))
    p y

  end

  def getAnyLocator(locator)

    str_pattern = /ctl[0-9]*_ctl[0-9]*_phContent_ctl[0-9]*_ctl/
    pageSource = @driver.page_source.to_s
    splitToNewline = pageSource.gsub(/\>/, ">\r\n")

    splitToNewline.each_line do |line|
      splitAddID = locator[35, locator.length()]
      lines_matcher = line.include? splitAddID
      if lines_matcher
        each_line_matcher = line.scan(str_pattern)
        if each_line_matcher
          getID_matcher = line.scan(/ctl[0-9]*_ctl[0-9]*_phContent_ctl[0-9]*_ctl[a-zA-z0-9]*/)
          return getID_matcher[0]
        else
          getID_matcher = line.scan(/ctl[a-zA-z0-9]*/)
          return getID_matcher[0]
        end
      end
    end

  end

end