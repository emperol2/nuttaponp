require 'test/unit'
require 'test/unit/testsuite'
require 'test/unit/data'
require 'selenium-webdriver'
require_relative '../cpbi_lib.rb'

#STDOUT = $stdout = File.open("C:/Users/nuttapon/Documents/ICRA/stdout.txt", "a+")
#STDERR = $stderr = File.open("C:/Users/nuttapon/Documents/ICRA/stderr.txt", "a+")

class CPBI_Live < Test::Unit::TestCase

  ######################################
  # 1. Homepage - Done
  # 2. Job Posting - Done
  # 3. Footer & Static pages - Done
  # 4. Event
  # 5. Member Registration
  # 6. News
  ######################################

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @CPBI_lib = CPBI_lib.new
    @driver = @CPBI_lib.driver
    @wait = @CPBI_lib.wait
    @baseURL = 'http://qa.cpbi-icra.ca/'
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @CPBI_lib.quit
  end

  ######################################
  ########## Homepage Section ##########
  ######################################

  def test_homepage
    # To change this template use File | Settings | File Templates.
    @driver.get(@baseURL)
    title = @driver.title
    assert_equal('Home', title, 'The title page is not "Home"')

    ##### Check Six Elements on Top Nav #####
    topNav = @driver.find_element(:id => 'main-menu')
    eachElem = topNav.find_elements(:css => 'li.menuitem')
    assert_equal(6, eachElem.count, 'Top Nav should have 6 elements')

    ##### Check Advertise Image #####
    imgTag = @driver.find_elements(:tag_name => 'img')
    findLastImg = imgTag.size() - 1
    imgTitle = imgTag[findLastImg].attribute('title') # get value from title attribute
    assert_not_nil(imgTag[findLastImg], 'Advertise with CPBI Image should not be nil')
    assert_equal('Advertise with CPBI ', imgTitle, 'Image title does not match')

    ##### Check Footer #####
    footer = @driver.find_element(:id => 'footer')
    assert_not_nil(footer, 'Footer should not be empty')
  end

  def test_homeUpcomingEvent
    @driver.get(@baseURL)
    ##### Check Upcoming Events #####
    upComingBox = @driver.find_element(:id => 'ui-id-1')
    upComingBox.click
    getUpComingLists = @driver.find_element(:css => 'div#tabs-events div.event-list')
    upComingLists = getUpComingLists.find_elements(:css => 'div.event-item')
    assert_not_nil(upComingLists.count, 'Upcoming Events should not be nil')
  end

  def test_homeFeaturedJobs
    @driver.get(@baseURL)
    ##### Check Featured Jobs #####
    featJobBox = @driver.find_element(:id => 'ui-id-2')
    featJobBox.click
    getFeatJobLists = @driver.find_element(:css => 'div#tabs-jobs div.job-list')
    featJobLists = getFeatJobLists.find_elements(:css => 'div.job-item')
    assert_not_nil(featJobLists.count, 'Featured jobs should not be nil')
  end

  ######################################
  ########## Job Section ###############
  ######################################

  def test_jobListing
    @driver.get(@baseURL)
    ##### Check Job Listing #####
    jobListing = @driver.find_element(:link_text => 'Job Listings')
    jobListing.click
    @CPBI_lib.getCodeError
    @CPBI_lib.getErrorBox
  end

  def test_jobPosting
    @driver.get(@baseURL)
    ##### Check Submit a Job Posting #####
    submitJob = @driver.find_element(:link_text => 'Submit a Job Posting')
    submitJob.click
    @CPBI_lib.getCodeError
    @CPBI_lib.getErrorBox
  end

  def test_jobDetails
    #### Call Job Listing #####
    test_jobListing
    #### Check Job Details #####
    @driver.find_element(:xpath => '//td/a').click # always the first job
    @CPBI_lib.getCodeError
    @CPBI_lib.getErrorBox
  end

  def test_jobSubmitResume
    ##### Call job Details #####
    test_jobDetails
    #### Check Job Details #####
    @driver.find_element(:id => 'btnApply').click # Click Apply for this position
    @driver.find_element(:id => 'btnSubmit').click # Click Submit for Resume
    @CPBI_lib.getCodeError
    @CPBI_lib.getErrorBox
  end

  ######################################
  ########## Footer Section ############
  ######################################

  def test_randStaticPages
    @driver.get(@baseURL)
    @arrayFooterText = Array.new
    ##### Random check for Static pages #####
    getAllFooterLinks = @driver.find_elements(:css => 'div#footer .level3')
    getAllFooterLinks.each do |l|
      @arrayFooterText.push(l.text) # push all link to array
    end

    (0..5).each do # random check footer link for 5 pages
      random_number = ((Random.new().rand * getAllFooterLinks.size) - 1).round
      @driver.find_element(:link_text => @arrayFooterText[random_number]).click
      p 'Navigate to : ' + @arrayFooterText[random_number]
      @CPBI_lib.getCodeError
      @CPBI_lib.getErrorBox
    end

  end

  ######################################
  ########## Event Section #############
  ######################################

  def test_eventRegion
    @driver.get(@baseURL)
    @driver.find_element(:xpath => '//*[@id="main-menu"]/li[2]/a').click # click at Event top Nav
    @driver.find_element(:link_text => 'SEARCH EVENTS').click # Go to all Events page
    getCountryToggle = @driver.find_element(:css => 'a.dropdown-toggle').text
    getCountryOnBrowse = @driver.find_element(:css => '.filter-option').text
    @CPBI_lib.assert_contains(getCountryToggle.downcase ,getCountryOnBrowse.downcase , 'Region of Event does not match')
  end

  def test_eventTitleDetailPage
    @driver.get(@baseURL)
    @driver.find_element(:xpath => '//*[@id="main-menu"]/li[2]/a').click # click at Event top Nav
    @driver.find_element(:link_text => 'SEARCH EVENTS').click # Go to all Events page
    getAllEvent = @driver.find_elements(:css => 'div.event-details-list .event-item .title') # Always get first event
    getTitle = getAllEvent[0].text
    getFirstEvent = getAllEvent[0]
    getFirstEvent.click
    title = @driver.title
    @CPBI_lib.assert_contains(title ,getTitle , 'Title of Event does not match')
  end

  def test_eventLists
    @driver.get(@baseURL)
    @driver.find_element(:xpath => '//*[@id="main-menu"]/li[2]/a').click # click at Event top Nav
    @driver.find_element(:link_text => 'SEARCH EVENTS').click # Go to all Events page
    assert_equal('Events', @driver.title, 'Title does not match')
    @CPBI_lib.getCodeError
    @CPBI_lib.getErrorBox

  end

  def test_eventRegistrationWithoutLogin
    test_eventRegion
    getAllRegistrationBtns = @driver.find_elements(:css => '.register-action a.btn-primary')
    getFirstBtn = getAllRegistrationBtns[0]
    getFirstBtn.click
    getCurrentURL = @driver.current_url
    assert(getCurrentURL.include?("Log-In"), 'Users should log in before register for Event')
    assert(@CPBI_lib.element_present?(:css, '.box-lines div#loginform-panel'), 'Users should get to log in before register for Event')
  end

  def test_eventRegistrationWithLogin
    test_eventRegion
    memberLogin
    getAllRegistrationBtns = @driver.find_elements(:css => '.register-action a.btn-primary')
    getFirstBtn = getAllRegistrationBtns[0]
    getFirstBtn.click
    getCurrentURL = @driver.current_url
    ##### NO NEED LOG IN PAGE #####
    assert_equal(false, getCurrentURL.include?("Log-In"), 'Users should not get to log in page after logged in')
    assert_equal(false, @CPBI_lib.element_present?(:css, '.box-lines div#loginform-panel'), 'Users should not get to log in page after logged in')
  end

  ######################################
  ########## Member Section ############
  ######################################

  def test_memberRegistration_Nonmember
    @driver.get(@baseURL)
    @driver.find_element(:id => 'lnkSignupPage').click
    assert_match('Sign Up for CPBI Profile', @driver.find_element(:css => '#contentcolumn h1').text, 'Not in Sign up page')
    ##### Need more logic here #####
  end

  def test_memberProfile
    @driver.get(@baseURL)
    memberLogin
    @driver.find_element(:link_text => 'View Account').click
    assert_equal('My Account', @driver.title, 'Title does not match')
    @driver.find_element(:id => 'lnkEditNameAndContactInfo').click
    @CPBI_lib.getCodeError
    @CPBI_lib.getErrorBox
  end

  def test_memberTaxExempt
    @driver.get(@baseURL)
    @driver.find_element(:id => 'lnkSignupPage').click
    assert_match('Sign Up for CPBI Profile', @driver.find_element(:css => '#contentcolumn h1').text, 'This is not Sign up page')
    ##### Select Associate membership class #####
    @driver.find_element(:name => 'ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl01$MembershipCategory').click
    sleep 3
    province = @driver.find_element(:id => 'ctl00_ctl00_phContent_ctl11_ctlAddressEditor_ddlProvince')
    get_province = province.find_elements(:tag_name => 'option')
    get_province[10].click # Select Price Edward Island
    @driver.find_element(:id => 'ctl00_ctl00_phContent_ctl11_ctlMemberAttributeEditor_rdoIsTaxExempt_0').click
    sleep 3
    invoice_total = @driver.find_element(:xpath => '//*[@id="invoicePanel"]/div[1]/div[3]/div/div[2]').text
    taxable_total = @driver.find_element(:xpath => '//*[@id="invoicePanel"]/div[1]/div[5]/div/div[2]').text
    tax = @driver.find_element(:xpath => '//*[@id="ctl00_ctl00_phContent_ctl11_ctlInvoicePanel_pnlGST"]/div/div[2]').text
    total_cost = @driver.find_element(:css => 'div.controls.total').text
    result = invoice_total.to_f + taxable_total.to_f + tax.to_f
    assert_equal(total_cost.to_f, result.to_f, 'Taxable total is incorrect value')
  end

  ######################################
  ########## News Section ##############
  ######################################

  def test_News
    @driver.get(@baseURL)
    @driver.find_element(:link_text => 'News').click
    @CPBI_lib.getErrorBox
    @CPBI_lib.getCodeError
  end

  ######################################
  ########## Library Section ###########
  ######################################

  def test_LibraryWithoutLogin
    @driver.get(@baseURL)
    @driver.find_element(:link_text => 'Library').click
    getAllFields = @driver.find_elements(:css => '.controls input')
    getTitleField = getAllFields[0]
    getTitleField.send_keys 'a' # search by 'a'
    @driver.find_element(:id => 'media-filter-submit').click
    onlyNumber = /[0-9+]/
    getText = @driver.find_element(:css => '.result-info').text
    getNumber = getText.match onlyNumber
    getNumber = getNumber[0]
    assert_not_equal('0', getNumber, 'Search result can not be zero !')
    @CPBI_lib.getErrorBox
    @CPBI_lib.getCodeError
  end

  def test_LibraryWithLogin
    @driver.get(@baseURL)
    memberLogin
    @driver.find_element(:link_text => 'Library').click
    assert_not_nil(@driver.find_element(:css => '.featured-media.featured-box'), 'Featured Item should be displayed !')
    @CPBI_lib.getErrorBox
    @CPBI_lib.getCodeError
  end

  ######################################
  ########## Global Functions ##########
  ######################################

  def memberLogin
    @driver.find_element(:css, 'li.linkitem').click
    @driver.find_element(:id, 'ctl00_ctl00_ctl37_ctlLoginView_ctlLogin_UserName').send_keys '20002'
    @driver.find_element(:id, 'ctl00_ctl00_ctl37_ctlLoginView_ctlLogin_Password').send_keys 'PI20002'
    @driver.find_element(:id, 'ctl00_ctl00_ctl37_ctlLoginView_ctlLogin_btnLogin').click
  end

  def string_difference_percent(a, b)
    longer = [a.size, b.size].max
    same = a.each_char.zip(b.each_char).select { |a,b| a == b }.size
    (longer - same) / a.size.to_f
  end

end