require 'rspec'
require 'selenium-webdriver'

describe 'My behaviour' do

  it 'should do something' do

    #To change this template use File | Settings | File Templates.
    true.should == false
  end

  it 'should open the website' do
    @driver = Selenium::WebDriver.for :firefox
    @driver.get('http://qa.healthnow.com')
    @driver.title.should == 'Login'
    assert(true)
  end

end