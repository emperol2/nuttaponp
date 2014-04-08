#require 'minitest/spec'
require 'selenium-webdriver'
# arranges for minitest to run (in an exit handler, so it runs last)
require 'minitest/autorun'
#require 'minitest'
require 'test/unit'
#require 'rspec'

require_relative '../myModel'

describe 'Alpha' do

  before(:all) do
    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to "http://newtours.demoaut.com/"
    @wait =  Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  after(:all) do
    @driver.quit
  end

  it "Verify User is able to  Login using credentials  on http://newtours.demoaut.com/" do
    @driver.find_element(:name,"userName").send_keys "mercury"
    @driver.find_element(:name,"password").send_keys "mercury"
    assert(@driver.find_element(:name, "login").displayed?)
    #@driver.find_element(:name,"login").click
    ##Wait until  'flight finder' appears
    #@wait.until {@driver.find_element(:xpath,"/html/body/div/table/tbody/tr/td[2]/table/tbody/tr[4]/td/table/tbody/tr/td[2]/table/tbody/tr/td/img")}
    ##checking user is navigated to home page
    #@driver.find_element(:css,"b  font  font").displayed?.should  == true
  end

  it 'greets you by name' do
    #Alpha.new.greet('Alice').must_equal('hello, Alice')
  end
end