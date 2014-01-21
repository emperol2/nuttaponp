require 'test/unit'
require 'selenium-webdriver'
require 'rubygems'
#gem "selenium-webdriver", "~> 2.37.0"
gem 'rspec'
gem 'syntax'
require_relative 'cpbi_lib.rb'


class Homepage < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @base_url = 'http://preview.cpbi-icra.ca'
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 60
    @verification_errors = []
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    # Do nothing
    @driver.quit()
    @verification_errors
  end

  ####################################################
  ########### Test Homepage Elements #################
  ########### with non logged in user ################
  ####################################################

  def test_A_Homepage_without_Login
    p 'Started - Homepage without login case'
    # To change this template use File | Settings | File Templates.
    #fail('Not implemented')
    @driver.get(@base_url)
    login = @driver.find_element(:link_text => 'LOG IN').text
    assert_equal(login, 'LOG IN'.encode('UTF-8'))
    username_field = @driver.find_element(:id => 'UserName')
    password_field = @driver.find_element(:id => 'Password')
    assert_not_nil(username_field)
    assert_not_nil(password_field)
    p 'Ended - Homepage without log in case\n'
  end

  ####################################################
  ########### Test Homepage Elements #################
  ########### with logged in user ####################
  ####################################################

  def test_B_Homepage_with_Login
    p 'Started - Homepage with login case'
    # To change this template use File | Settings | File Templates.
    #fail('Not implemented')
    @driver.get(@base_url)
    login = @driver.find_element(:link_text => 'LOG IN').text
    assert_equal(login, 'LOG IN'.encode('UTF-8'))

    @driver.find_element(:id => 'UserName').send_key('0001')
    @driver.find_element(:id => 'Password').send_key('LE0001')
    @driver.find_element(:id => 'btnLogin').click
    @id_number = /[1-9][0-9]*/
    if element_present?(:id, 'ctl00_ctl00_ctl37_ctlLoginView_lnkMyAccount')
      myaccount_link = @driver.find_element(:id => 'ctl00_ctl00_ctl37_ctlLoginView_lnkMyAccount')
      myname = @driver.find_element(:id => 'ctl00_ctl00_ctl37_ctlLoginView_lblLogonUser').text
      logon_panel = @driver.find_element(:id => 'logonbox-panel').displayed?
      logon_name = @driver.find_element(:id => 'lblLogonUser').text
      assert_not_nil(myaccount_link)
      verify { assert_equal(myname, 'MR. NUTTAPON PICHETPONGSA'.encode('UTF-8'), 'You are already logged on but you are not Nuttapon') }
      assert_equal(logon_name, myname, 'Name on my account link and my account page are not equal')
      assert(logon_panel)
    else
      fail('My account link does not present')
    end
    p 'Ended - Homepage with login case\n'

  end

  def test_C_My_Account_page
    p 'Started - My account case'
    @driver.get(@base_url)
    logged_on()
    has_warning_box = true
    if has_warning_box == false
      puts 'No Event registered for this Member'
    else
      puts 'There is Event registered for this Member'
      my_member_purchase = @driver.find_elements(:xpath => '//*[@id="membershipAndProfilePanel"]/h4')
      my_member_purchase.each do |h|
        if(h.text() == 'MY MEMBERSHIP AND PROFILE'.encode('UTF-8'))
          puts 'MY MEMBERSHIP AND PROFILE'
        elsif h.text() == 'MY PURCHASES'.encode('UTF-8')
          puts 'MY PURCHASES'
        else
          fail('NO MY MEMBERSHIP AND PROFILE & MY PURCHASES')
        end
      end
      assert(@driver.find_element(:xpath => '//*[@id="membershipAndProfilePanel"]/div[2]/h4').displayed?,'MY Event Element NOT FOUND')
      has_upcoming_event()
    end
    p 'Ended - My account case\n'

  end

  def test_D_Sign_up_NonMember
    p 'Started - Sign up non-member case'
    @driver.get(@base_url)
    @driver.find_element(:id => 'lnkSignupPage').click
    assert_match('Sign Up for CPBI Profile', @driver.find_element(:css => '#contentcolumn h1').text, 'Not in Sign up page')

    @verify_button = @driver.find_element(:id => 'btnNextToVerifyDetail')

    ##### Non-member #####
    @driver.find_element(:name => 'ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl03$MembershipCategory').click
    puts 'Non member type'
    @verify_button.click
    sleep 3
    assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqProvince').displayed?, 'Province does not require field')
    assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqAddress').displayed?, 'Address does not require field')
    assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPostalCode').displayed?, 'Postal does not require field')
    assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqCity').displayed?, 'City does not require field')
    assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPhone').displayed?, 'Phone does not require field')
    sleep 3

    ##### Associate #####
    @driver.find_element(:name => 'ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl01$MembershipCategory').click
    sleep 3
    puts 'Associate'
    @verify_button = nil
    @verify_button = @driver.find_element(:id => 'btnNextToVerifyDetail')
    @verify_button.click
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqProvince').displayed?, 'Province is require field')
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqAddress').displayed?, 'Address is require field')
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPostalCode').displayed?, 'Postal is require field')
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqCity').displayed?, 'City is require field')
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPhone').displayed?, 'Phone is require field')
    sleep 3

    ##### Student #####
    @driver.find_element(:name => 'ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl02$MembershipCategory').click
    sleep 3
    puts 'Student'
    @verify_button = nil
    @verify_button = @driver.find_element(:id => 'btnNextToVerifyDetail')
    @verify_button.click
    # Post secondary institution
    assert(element_present?(:id, 'ctl00_ctl00_phContent_ctl11_ctlMemberAttributeEditor_ctlMemberAttributeCustomAttributesEditor_ControlGenerator_RowPanel_a664891afde14d129c7d2a40520e89fa'), 'Tax Exempt should be shown on Student class')
    # Student Number
    assert(element_present?(:id, 'ctl00_ctl00_phContent_ctl11_ctlMemberAttributeEditor_ctlMemberAttributeCustomAttributesEditor_ControlGenerator_RowPanel_d89e10bfd659486c97af544ac11501e8'), 'Continuing Education Credits should be shown on Student class')
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqProvince').displayed?, 'Province is require field')
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqAddress').displayed?, 'Address is require field')
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPostalCode').displayed?, 'Postal is require field')
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqCity').displayed?, 'City is require field')
    assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPhone').displayed?, 'Phone is require field')

    p 'Ended - Sign up non-member case\n'
  end

  def test_E_Tax_exempt
    p 'Started - Tax exempt case'
    @driver.get(@base_url)
    @driver.find_element(:id => 'lnkSignupPage').click
    assert_match('Sign Up for CPBI Profile', @driver.find_element(:css => '#contentcolumn h1').text, 'Not in Sign up page')

    @driver.find_element(:name => 'ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl01$MembershipCategory').click
    sleep 3

    province = @driver.find_element(:id => 'ctl00_ctl00_phContent_ctl11_ctlAddressEditor_ddlProvince')
    get_province = province.find_elements(:tag_name => 'option')
    get_province[10].click

    ## TAX EXEMPT = YES ##
    @driver.find_element(:id => 'ctl00_ctl00_phContent_ctl11_ctlMemberAttributeEditor_rdoIsTaxExempt_0').click
    sleep 3
    tax_exempt()

    ## TAX EXEMPT = NO ##
    @driver.find_element(:id => 'ctl00_ctl00_phContent_ctl11_ctlMemberAttributeEditor_rdoIsTaxExempt_1').click
    sleep 3
    tax_exempt()

    p 'Ended - Tax exempt case\n'

  end


  # Check Tool & Resources box, Members, News
  def assert_three_main_boxes

    tool_resources = @driver.find_element(:css => '.widget-box.edge-frame.purple')
    assert_not_nil(tool_resources, 'Not Found - Tool & Resources box')

    members = @driver.find_element(:css => '.widget-box.edge-frame.darkgreen')
    assert_not_nil(members, 'Not Found - Members box')

    news = @driver.find_element(:css => '.widget-box.edge-frame.orange')
    assert_not_nil(news, 'Not Found - News box')

  end

  def logged_on
    widget_box = @driver.find_element(:css => '.widget-box')
    # if Log In box appears
    if widget_box != nil
      @driver.find_element(:id => 'UserName').send_key('0001')
      @driver.find_element(:id => 'Password').send_key('LE0001')
      @driver.find_element(:id => 'btnLogin').click
      logon_name = @driver.find_element(:id => 'lblLogonUser').text
      assert_equal(logon_name, 'M. GERMAIN LEBEL'.encode('UTF-8'), 'Logon name does not match')
      @driver.find_element(:id => 'lnkMyAccount').click
    else
      fail('NO WIDGET BOX')
    end

  end

  def has_upcoming_event
    assert(@driver.find_element(:css => '#membershipAndProfilePanel .my-events h4').displayed?, 'Event Element NOT FOUND')
    event_number = @driver.find_element(:xpath => '//*[@id="membershipAndProfilePanel"]/div[2]/div[1]/strong').text
    reg = /[a-zA-Z]+/
    #upcoming_event = /[a-zA-Z]+/.match(event_number)
    matches = reg.match(event_number)
    matches[1 .. matches.length].each do |x|
      assert_equal(x, 'My Upcoming Events'.encode('UTF-8'), 'NO UP COMING EVENTS')
    end
  end

  def has_purchases
    assert(@driver.find_element(:css => '#membershipAndProfilePanel .my-events h4').displayed?, 'Event Element NOT FOUND')
    event_number = @driver.find_element(:xpath => '//*[@id="membershipAndProfilePanel"]/div[2]/div[1]/strong').text
    reg = /[a-zA-Z]+/
    #upcoming_event = /[a-zA-Z]+/.match(event_number)
    matches = reg.match(event_number)
    matches[1 .. matches.length].each do |x|
      assert_equal(x, 'My Upcoming Events'.encode('UTF-8'), 'NO UP COMING EVENTS')
    end
  end




  ##############################
  ########## Method ############
  ##############################

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

  ######################################################

  module Test::Unit::Assertions
    def assert_false(object, message = '')
      assert_equal(false, object, message)
    end
  end

  ###############################################

  def login_backend
    @driver.get('http://qa.cpbi-icra.ca/Composite/top.aspx')
    @driver.find_element(:css => 'input[name="username"]').send_key('ofsupport')
    @driver.find_element(:css => 'input[name="password"]').send_key('0p3nf4c3')
    @driver.find_element(:css => 'input[name="password"]').send_keys :return
  end

  def select_iframeid
    storeHtmlSource = @driver.page_source
    storeHtmlSource2 = storeHtmlSource.gsub(/frameborder="0" /, '')
    index = storeHtmlSource2.to_s.match(/iframe id="[a-z]+[0-9]+"/)
    @iframe = index[0].match(/[a-z]+[0-9]+/)
  end

  def tax_exempt
    invoice_total, taxable_total, tax, total_cost, result = nil
    invoice_total = @driver.find_element(:xpath => '//*[@id="invoicePanel"]/div[1]/div[3]/div/div[2]').text
    taxable_total = @driver.find_element(:xpath => '//*[@id="invoicePanel"]/div[1]/div[5]/div/div[2]').text
    tax = @driver.find_element(:xpath => '//*[@id="ctl00_ctl00_phContent_ctl11_ctlInvoicePanel_pnlGST"]/div/div[2]').text
    total_cost = @driver.find_element(:css => 'div.controls.total').text
    if @driver.find_element(:id => 'ctl00_ctl00_phContent_ctl11_ctlMemberAttributeEditor_rdoIsTaxExempt_0').selected?
      result = invoice_total.to_f + taxable_total.to_f + tax.to_f
      assert_equal(total_cost.to_f, result.to_f, 'Taxable total failed')
    else
      taxable_total = nil
      taxable_total = @driver.find_element(:xpath => '//*[@id="invoicePanel"]/div[1]/div[4]/div/div[2]').text
      result = taxable_total.to_f + tax.to_f
      assert_equal(total_cost.to_f, result.to_f, 'Taxable total failed')
    end
  end

  def verify(&blk)
    yield
  rescue MiniTest::Assertion => ex
    @verification_errors << ex
  end

end
