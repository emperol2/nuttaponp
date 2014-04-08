require 'test/unit'
require 'test/unit/assertions'
require 'selenium-webdriver'

class UI_frontEnd < Test::Unit::TestCase
  attr_accessor :driver

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @profile = Selenium::WebDriver::Firefox::Profile.from_name 'default'
    @profile['network.cookie.cookieBehavior'] = '2'
    @profile.native_events = true
    @driver = Selenium::WebDriver.for :firefox, :profile => @profile
    #@driver.manage.window.maximize
    @driver.manage.window.resize_to(320, 600)
    @driver.manage.timeouts.implicit_wait = 20
    @wait = Selenium::WebDriver::Wait.new :timeout => 120
    @baseURL = 'http://qa.healthnow.com'
    #@verification_errors = []

  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
  end

  # Fake test
  #def test_fail
  #
  #  # To change this template use File | Settings | File Templates.
  #  fail('Not implemented')
  #end

  def test_HomePage
    @driver.get(@baseURL)
    hnLogo = element_present?(:id, 'lnkHNLogo')
    assert(hnLogo, 'The Logo does not show up')
    hnBanner = element_present?(:id, 'divTagline')
    assert(hnBanner, 'The HN banner does not show up')
    usernameField = element_present?(:id, 'txtUsername')
    assert(usernameField, 'The Username field does not show up')
    passwordField = element_present?(:id, 'txtPassword')
    assert(passwordField, 'The Password field does not show up')
    loginBtn = element_present?(:id, 'btnLogin')
    assert(loginBtn, 'The Login button does not show up')
    cancelBtn = element_present?(:id, 'btnHelp')
    assert(cancelBtn, 'The Cancel button does not show up')
  end

  def test_PatientHomepage
    logInAsPatient()
    assert_equal('Profile', @driver.title)
    assert_equal('Self Assessment', @driver.find_element(:css, '#selfAssessmentPanel #header').text)
    assert_equal('Issues', @driver.find_element(:css, '#issuePanel #header').text)
    assert_equal('Medications', @driver.find_element(:css, '#medicationsPanel #header').text)
    assert_equal('Goals', @driver.find_element(:css, '#interventionsPanel #header').text)
  end

  #################################
  ########## PATIENT PROFILE ######
  #################################

  ########## ADD ISSUES HAVE BEEN REMOVED ##########

  #def test_PatientAddIssues
  #  logInAsPatient()
  #  assert_equal('Profile', @driver.title)
  #  #getTopThreeIssues = @driver.find_element(:css, '#issuePanel .item-list')
  #  #count = getTopThreeIssues.find_elements(:css, '.item').length
  #  @driver.find_element(:css, '#issuePanel .btn-new').click
  #  @driver.find_element(:css, '#issuePanel #txtTitle').send_keys 'test issues'
  #  @driver.find_element(:css, '#issuePanel #btnSave').click
  #
  #end

  ########## ADD MEDICATIONS HAVE BEEN REMOVED ##########

  #def test_PatientAddMedications
  #  logInAsPatient()
  #  assert_equal('Profile', @driver.title)
  #  #getTopThreeIssues = @driver.find_element(:css, '#issuePanel .item-list')
  #  #count = getTopThreeIssues.find_elements(:css, '.item').length
  #  @driver.find_element(:css, '#medicationsPanel .btn-new').click
  #  @driver.find_element(:css, '#medicationsPanel #txtTitle').send_keys 'test Medications'
  #  @driver.find_element(:css, '#medicationsPanel #btnSave').click
  #
  #end

  ########## ADD GOALS HAVE BEEN REMOVED ##########

  #def test_PatientAddGoals
  #  logInAsPatient()
  #  assert_equal('Profile', @driver.title)
  #  #getTopThreeIssues = @driver.find_element(:css, '#issuePanel .item-list')
  #  #count = getTopThreeIssues.find_elements(:css, '.item').length
  #  @driver.find_element(:css, '#interventionsPanel .btn-new').click
  #  @driver.find_element(:css, '#interventionsPanel #txtTitle').send_keys 'test Goals'
  #  @driver.find_element(:css, '#interventionsPanel #btnSave').click
  #
  #end

  def test_PatientEditIssues

    logInAsPatient()
    assert_equal('Profile', @driver.title)
    #getTopThreeIssues = @driver.find_element(:css, '#issuePanel .item-list')
    #count = getTopThreeIssues.find_elements(:css, '.item').length
    @driver.find_element(:xpath, '//*[@id="issuePanel"]/div/div[3]/div[1]/div[3]/div/a/img').click
    @driver.find_element(:css, '#issuePanel #itemDescr').clear
    @driver.find_element(:css, '#issuePanel #itemDescr').send_keys 'test first issues'
    @driver.find_element(:css, '#issuePanel').click
    sleep 1
    assert_equal('test first issues', @driver.find_element(:xpath, '//*[@id="issuePanel"]/div/div[3]/div[1]/div[1]/div[1]').text)

  end

  #################################
  ###### HEALTH TEAM LIST #########
  #################################

  def test_PatientHealthTeamList
    logInAsPatient()
    assert_equal('Profile', @driver.title)
    @driver.find_element(:css, '#content-wrapper > div.top-user-info > div > div.btn-team-menu.pull-right > a > img').click
    assert_equal('Community Team', @driver.find_element(:css, '#communityTeam #header').text)
    assert_equal('Inpatient Team', @driver.find_element(:css, '#inpatientTeam #header').text)

  end

  #################################
  ########## ADD PROVIDER #########
  #################################

  def test_PatientAddCommunityTeam
    test_PatientHealthTeamList()
    @driver.find_element(:css, '#communityTeam #btnAddTeam01').click
    assert_equal('Provider Details', @driver.title)
    @driver.find_element(:id, 'textName').send_keys 'provider'
    selectOption = @driver.find_element(:id, 'ddlCommunity')
    option = selectOption.find_elements(:tag_name, 'option')
    option.each do |x|
      if x.text == 'Child'
        x.click
        break;
      end
    end
    @driver.find_element(:id, 'btnProviderSave').click
    sleep 2
    assert_equal('provider', @driver.find_element(:css, '#communityTeam .last-row').text)
  end

  def test_PatientAddInpatientTeam
    test_PatientHealthTeamList()
    @driver.find_element(:css, '#inpatientTeam #btnAddTeam02').click
    assert_equal('Provider Details', @driver.title)
    @driver.find_element(:id, 'textName').send_keys 'provider'
    selectOption = @driver.find_element(:id, 'ddlInpatient')
    option = selectOption.find_elements(:tag_name, 'option')
    option.each do |x|
      if x.text == 'CCAC Coordinator'
        x.click
        break;
      end
    end
    @driver.find_element(:id, 'btnProviderSave').click
    sleep 2
    assert_equal('provider', @driver.find_element(:css, '#inpatientTeam .last-row').text)
  end

  ##################################
  ########## EDIT PROVIDER #########
  ##################################

  def test_PatientEditCommunityTeam
    test_PatientHealthTeamList()
    getName = @driver.find_element(:css, '#inpatientTeam .last-row')
    @driver.find_element(:css, '#communityTeam-list > div.item.last-row.clearfix > div.pull-right.button-panel > a > img').click
    getOption = @driver.find_element(:id, 'ddlCommunity')
    #getChild = getOption[2]
    #assert_equal('Provider', @driver.find_element(:css, '#textName').text)
    assert_equal('Child', getOption.text)
    get_js_error_feedback
  end

  #################################
  ############# QUIZ ##############
  #################################

  def test_QuizIndex
    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/Index.aspx')
    assert_equal('Health Now Exercises', @driver.title)

    part1 = @driver.find_element(:css, '.part-1 .part-header').text
    part2 = @driver.find_element(:css, '.part-2 .part-header').text

    assert_equal('Part 1: Getting to Know You', part1)
    assert_equal('Part 2: Participating In Your Treatment', part2)

  end

  #################################
  ########## ALL WIDGETs ##########
  #################################

  def test_WidgetTEXT

    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=1&ex=1&q=1')
    # Check widget Textbox
    assert(@driver.find_element(:css, '.widget-textbox'))

  end

  def test_WidgetAddProvider

    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=1&ex=1&q=4')
    # Check widget Add Provider
    assert(@driver.find_element(:css, '.widget-add-provider'))

  end

  def test_WidgetBinary

    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=1&ex=2&q=12')
    # Check widget Binary
    assert(@driver.find_element(:css, '.widget-binary'))

  end

  def test_WidgetDimensionIssue

    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=1&ex=2&q=12')
    # Check widget Binary
    assert(@driver.find_element(:css, '.widget-dimension-issue'))

  end

  def test_WidgetScale

    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=1&ex=1&q=3')
    # Check widget Scale
    assert(@driver.find_element(:css, '.widget-scale'))

  end

  def test_WidgetNote

    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=2&ex=8&q=39')
    # Check widget Note
    assert(@driver.find_element(:css, '.widget-note'))

  end

  def test_WidgetTransaction

    logInAsPatient
    #@driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=1&ex=1&q=3')
    # Check widget Transaction
    assert(@driver.find_element(:css, '.widget-transaction'))

  end

  def test_WidgetSkip

    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=1&ex=1&q=1')
    @driver.find_element(:css, 'a#lnkSkip').click
    # Check widget Skip
    assert(@driver.find_element(:css, '.modal-skip-question'))

  end

  def test_WidgetSourceList

    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=1&ex=1&q=1')
    @driver.find_element(:css, 'a#lnkChangeSource').click
    sleep 2
    # Check widget Source list
    assert(@driver.find_element(:css, '.modal-source-list'))

  end

  #################################
  ############ Responses ##########
  #################################

  def test_ResponseTextbox

    logInAsPatient
    @driver.navigate.to('http://qa.healthnow.com/Pages/Quiz/DoQuiz.aspx?part=1&ex=1&q=1')
    @driver.find_element(:css, '.widget-container input.hn-textbox').send_keys 'test response'
    @driver.find_element(:css, 'a#lnkReply').click

    # Check response on screen
    assert(@driver.find_element(:css, '.conversation-row'))
    assert_equal('test response', @driver.find_element(:css, '.content').text)
    get_js_error_feedback

  end



  ######################################
  ########## Global Functionality ######
  ######################################

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

  def logInAsPatient
    @driver.get(@baseURL)
    @driver.find_element(:id, 'txtUsername').send_keys 'patient'
    @driver.find_element(:id, 'txtPassword').send_keys 'patient'
    @driver.find_element(:id, 'btnLogin').click
    jsLOGGER
    #puts @cookies = @driver.manage.all_cookies
  end

  def logInAsProvider
    @driver.get(@baseURL)
    @driver.find_element(:id, 'txtUsername').send_keys 'provider'
    @driver.find_element(:id, 'txtPassword').send_keys 'provider'
    @driver.find_element(:id, 'btnLogin').click
    #puts @cookies = @driver.manage.all_cookies
  end

  def jsLOGGER
    error = '"window.collectedErrors = [];"
  + "window.onerror = function(errorMessage) { "
  + "window.collectedErrors[window.collectedErrors.length] = errorMessage;"
  + "}";'
    puts @driver.execute_script(error)
  end

  def get_js_error_feedback
    jserror_descriptions = ''
    begin
      jserrors = @driver.execute_script('return window.JSErrorCollector_errors.pump()')
      jserrors.each do |jserror|
        jserror_descriptions += 'JS error detected:' + jserror
      end
    rescue Exception => e
      'Checking for JS errors failed with: #{e}'
    end
    jserror_descriptions
  end

end