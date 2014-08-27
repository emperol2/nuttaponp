require 'rspec'
require 'selenium-webdriver'

describe 'HealthNow Admin behaviour' do
  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 20
    @wait = Selenium::WebDriver::Wait.new :timeout => 120
    @baseURL = 'http://dev-admin.healthnow.net/Login.aspx'

  end

  it 'should be able to log in as Admin' do
    login()

    # verify things here
    expect(element_present?(:class, 'topLink')).to be_true
    expect(element_present?(:id, 'pnlPersonManager')).to be_true
    expect(element_present?(:id, 'pnlDimensionManager')).to be_true

  end

  it 'should be able to create the person' do
    login()
    # select Person/ User Creation
    @driver.find_element(:css, '#pnlPersonManager > div:nth-child(1)').click
    @driver.find_element(:link_text, 'Person/User Creation').click
    # Fill Person information
    fillPersonInformation()
    expect(@driver.find_element(:id, 'MPContent_lblComplete').text).to eq('Add Person Successfully')
  end

  it 'should be able to create patient' do
    login()
    # select Person/ User Creation
    @driver.find_element(:css, '#pnlPersonManager > div:nth-child(1)').click
    @driver.find_element(:link_text, 'Patient Creation/Update').click
    # Fill Patient information
    fillPatient()
    expect(@driver.find_element(:id, 'MPContent_lblComplete').text).to eq('Create or Update Patient Successfully')

  end

  after(:each) do
    @driver.quit
  end

  def login
    @driver.get(@baseURL)
    @driver.title.should == 'Health Now! Administration'
    @driver.find_element(:id, 'MPContent_txtUsername').send_keys 'papajohn_jr'
    @driver.find_element(:id, 'MPContent_txtPassword').send_keys '1981papajohn_jr'
    @driver.find_element(:id, 'MPContent_btnLogin').click
  end

  def fillPersonInformation
    x = Random.new()
    randNum = (x.rand * 50000).round
    puts "your random number is #{randNum}"
    @driver.find_element(:id, 'MPContent_txtFirstName').send_keys 'rubyFirstname' + randNum.to_s
    @driver.find_element(:id, 'MPContent_txtLastName').send_keys 'rubyLastname' + randNum.to_s
    @driver.find_element(:id, 'MPContent_txtEmail').send_keys 'rubyemail' + randNum.to_s + '@gmail.com'
    @driver.find_element(:id, 'txtDOB').click
    @driver.find_element(:link_text, '1').click
    @driver.find_element(:id, 'MPContent_txtUserName').send_keys 'ruby' + randNum.to_s
    @driver.find_element(:id, 'MPContent_txtPassword').send_keys '12345678'
    @driver.find_element(:id, 'MPContent_txtConfirmPassword').send_keys '12345678'
    @driver.find_element(:id, 'MPContent_btnCreate').click
    sleep 2
  end

  def fillPatient
    @driver.find_element(:id, 'MPContent_txtFullName').send_keys 'ruby'
    sleep 1
    autocomplete = @driver.find_element(:class, 'ui-autocomplete')
    nodeCount = autocomplete.find_elements(:tag_name, 'li')
    @driver.find_element(:css, '#ui-id-1 > li:nth-child('+nodeCount.length.to_s+')').click
    @driver.find_element(:id, 'txtDOA').click
    @driver.find_element(:link_text, '1').click
    @driver.find_element(:id, 'MPContent_txtLocation').send_keys 'Bangkok'
    @driver.find_element(:id, 'btnCreate').click
    sleep 2
  end

  def element_present?(how, what)
    found = @driver.find_element(how => what)
    if found
      true # return true if this element is found
    else
      false # return false if this element is not found
    end
  rescue Selenium::WebDriver::Error::NoSuchElementError # catch if NoSuchElementError appears
    false
  end
end