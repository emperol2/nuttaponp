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
    @base_url = 'http://icra-dev.openface.com/'
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 20
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit()
  end

  ####################################################
  ########### Test Homepage Elements #################
  ########### with non logged in user ################
  ####################################################

  def test_homepage_elements_not_login

    # To change this template use File | Settings | File Templates.
    #fail('Not implemented')
    @driver.get(@base_url)
    #@driver.find_element(:css => '#logo').click
    login = @driver.find_element(:link_text => 'LOG IN').text
    assert_equal(login, 'LOG IN'.encode('UTF-8'))

    widget_box = @driver.find_element(:css => '.widget-box')
    # if Log In box appears
    if widget_box != nil
      username_field = @driver.find_element(:id => 'UserName')
      password_field = @driver.find_element(:id => 'Password')

      #puts username_field
      has_username = assert_not_nil(username_field)
      has_password = assert_not_nil(password_field)

      if has_username == true && has_password == true
        # Check Tool & Resources box, Members, News
        assert_three_main_boxes()

        #verify_widget_box()
        puts __method__

      else
        fail('User logged on')
      end

    else
      fail('No Widget Box')
    end

  end


  ####################################################
  ########### Test Homepage Elements #################
  ########### with logged in user ####################
  ####################################################

  def test_homepage_elements_with_login

    # To change this template use File | Settings | File Templates.
    #fail('Not implemented')
    @driver.get(@base_url)
    #@driver.find_element(:css => '#logo').click
    login = @driver.find_element(:link_text => 'LOG IN').text
    assert_equal(login, 'LOG IN'.encode('UTF-8'))

    widget_box = @driver.find_element(:css => '.widget-box')
    # if Log In box appears
    if widget_box != nil
      @driver.find_element(:id => 'UserName').send_key('20041')
      @driver.find_element(:id => 'Password').send_key('PI20041')
      #@driver.find_element(:css => 'input#btnLogin.button').submit
      #@driver.execute_script("document.getElementById('Password').focus(); document.getElementById('Password').value = 'PI20041';")
      @driver.find_element(:id => 'btnLogin').click

      if element_present?(:id, 'ctl00_ctl00_ctl19_ctlLoginView_lnkMyAccount')
        myaccount_link = @driver.find_element(:id => 'ctl00_ctl00_ctl19_ctlLoginView_lnkMyAccount')
        myname = @driver.find_element(:id => 'ctl00_ctl00_ctl19_ctlLoginView_lblLogonUser').text
        logon_panel = @driver.find_element(:id => 'logonbox-panel').displayed?
        logon_name = @driver.find_element(:id => 'lblLogonUser').text

        #puts username_field
        has_myaccount_link = assert_not_nil(myaccount_link)
        has_myname = assert_equal(myname, 'MR. NUTTAPON PICHETPONGSA'.encode('UTF-8'))
        assert_equal(logon_name, 'MR. NUTTAPON PICHETPONGSA'.encode('UTF-8'), 'Logon name does not match')
        has_logon_panel = assert(logon_panel)

      else

        if has_myaccount_link == true && has_myname == true && has_logon_panel == true
          # Check Tool & Resources box, Members, News
          assert_three_main_boxes()

          #verify_widget_box()
          puts __method__

        else

          fail('User logged on')

        end

      end

    else
      fail('No Widget Box')
    end

  end

  def test_my_account
    @driver.get(@base_url)
    logged_on()

    #has_warning_box = @driver.find_element(:css => '.warning-box-outer-panel').element_present?
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

  end

  def test_sign_up
    @driver.get(@base_url)
    @driver.find_element(:id => 'lnkSignupPage').click
    assert_match('Sign Up for CPBI Profile', @driver.find_element(:css => '#contentcolumn h1').text, 'Not in Sign up page')

    verify_button = @driver.find_element(:id => 'btnNextToVerifyDetail')

    #### Non-member, Associate and Student
    profile_type = %w[ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl03$MembershipCategory ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl01$MembershipCategory ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl02$MembershipCategory]

    profile_type.each do |p|
      @driver.find_element(:name => p).click

      non_member_type = @driver.find_element(:name => 'ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl03$MembershipCategory').selected?
      associate_type = @driver.find_element(:name => 'ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl01$MembershipCategory').selected?
      student_type = @driver.find_element(:name => 'ctl00$ctl00$phContent$ctl11$rptMembershipClass$ctl02$MembershipCategory').selected?
      #### NO Address, Postal, City field are required
      if non_member_type

        puts 'Non member type'
        verify_button.click
        #assert_match('Non Member', @driver.find_element(:xpath => '//*[@id="pnlProfileType"]/div[2]/div/div/span/label/b').text, 'Not Non Member Type')

        assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqProvince').displayed?, 'Province does not require field')
        assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqAddress').displayed?, 'Address does not require field')
        assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPostalCode').displayed?, 'Postal does not require field')
        assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqCity').displayed?, 'City does not require field')
        assert_false(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPhone').displayed?, 'Phone does not require field')

        #### NO Title and Employer ####
      elsif associate_type || student_type

        #### NO Tax Exempt and Continuing Education Credits #####
        if student_type
          puts 'Student type'

          @wait.until {@driver.find_element(:id => 'vldCountNumberOfErrors')}
          verify_button = @driver.find_element(:id => 'btnNextToVerifyDetail').click

          #assert_match('Student', @driver.find_element(:xpath => '//*[@id="pnlProfileType"]/div[5]/div/div/span/label/b').text, 'Not Student Type')
          assert_false(element_present?(:id, 'ctl00_ctl00_phContent_ctl11_ctlMemberAttributeEditor_pnlTaxExempt'), 'Tax Exempt does not require field')
          assert_false(element_present?(:id, 'ctl00_ctl00_phContent_ctl11_ctlMemberAttributeEditor_pnlCECredits'), 'Continuing Education Credits does not require field')
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqProvince').displayed?, 'Province does not require field')
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqAddress').displayed?, 'Address does not require field')
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPostalCode').displayed?, 'Postal does not require field')
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqCity').displayed?, 'City does not require field')
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPhone').displayed?, 'Phone does not require field')
        end

        if associate_type
          puts 'Associate type'
          #begin
          #  @wait.until {@driver.find_element(:name, 'ctl00$ctl00$phContent$ctl11$btnNextToVerifyDetail')}
          #  verify_button.click
          #  @wait.until {@driver.find_element(:name, 'ctl00$ctl00$phContent$ctl11$btnNextToVerifyDetail')}
          #rescue Selenium::WebDriver::Error::StaleElementReferenceError
          #  @driver.quit
          #end

          @wait.until {@driver.find_element(:id => 'vldCountNumberOfErrors')}
          verify_button = @driver.find_element(:id => 'btnNextToVerifyDetail').click

          #assert_match('Associate', @driver.find_element(:xpath => '//*[@id="pnlProfileType"]/div[4]/div/div/span/label/b').text, 'Not Associate Type')
          #puts @driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqProvince').displayed?
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqProvince').displayed?, 'Province does not require field')
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqAddress').displayed?, 'Address does not require field')
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPostalCode').displayed?, 'Postal does not require field')
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqCity').displayed?, 'City does not require field')
          assert(@driver.find_element(:css, 'span#ctl00_ctl00_phContent_ctl11_ctlAddressEditor_vldReqPhone').displayed?, 'Phone does not require field')

        end

      end

    end

  end

  def test_tax_exempt

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

  end

  #def test_Event_BackEnd
  #  login_backend()
  #  sleep 15
  #  select_iframeid()
  #  #puts @iframe.to_s
  #  @driver.switch_to.frame(@iframe.to_s)
  #
  #  ####### Switch to explorer frame #######
  #  list_home_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  get_explorer_iframe = list_home_iframe[3]
  #  @driver.switch_to.frame(get_explorer_iframe)
  #
  #  ####### Switch to system view (tree) frame #######
  #  list_system_view_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  get_system_view_iframe = list_system_view_iframe[0]
  #  @driver.switch_to.frame(get_system_view_iframe)
  #
  #  ####### unwrap page source to each line, and click at 'CPBI Members' tree #######
  #  tree_pagesource2 = @driver.page_source
  #  tree_pagesource2 = tree_pagesource2.to_s
  #  newline_tree = tree_pagesource2.gsub(/\>/, "\n")
  #
  #  @ary = Array.new
  #  newline_tree.each_line do |line|
  #
  #    matcher_member = line.include? 'Members for CPBI'
  #
  #    if matcher_member
  #
  #      get_all_member = line.scan(/key[0-9]+/)
  #
  #      get_all_member.each do |key|
  #        @ary.push(key)
  #      end
  #
  #    end
  #
  #  end
  #
  #  #puts get_key_member = @ary[3]
  #  get_key_member = @ary[3]
  #  @driver.action.double_click(@driver.find_element(:xpath, '//*[@id="'+get_key_member+'"]')).perform
  #  sleep 5
  #
  #  ####### unwrap page source to each line, and click at 'Users' tree #######
  #  user_pagesource = @driver.page_source
  #  user_pagesource = user_pagesource.to_s
  #  newline_user = user_pagesource.gsub(/\>/, "\n")
  #
  #  @ary2 = Array.new
  #  #newline_tree3.each_line do |x|
  #  #
  #  #  #reg = /Members for CPBI/
  #  #
  #  #  matcher = x.include? 'Users'
  #  #
  #  #  #matcher = x.scan('Members for CPBI')
  #  #  if matcher
  #  #    #matcher.each do |y|
  #  #
  #  #    matcher2 = x.scan(/key[0-9]+/)
  #  #    matcher2.each do |z|
  #  #      #puts z
  #  #
  #  #      @ary2.push(z)
  #  #    end
  #  #  end
  #  #
  #  #end
  #
  #  matcher_user = newline_user.scan(/key[0-9]+" label="Users"/)
  #
  #  matcher_user.each do |line|
  #    get_all_user = line.scan(/key[0-9]+/)
  #
  #    get_all_user.each do |key|
  #      @ary2.push(key)
  #    end
  #
  #  end
  #
  #  #puts get_key_user = @ary2[1]
  #  get_key_user = @ary2[1]
  #  @driver.action.click(@driver.find_element(:xpath, '//*[@id="'+get_key_user+'"]')).perform
  #  sleep 5
  #
  #  @driver.switch_to.default_content
  #  select_iframeid()
  #  @driver.switch_to.frame(@iframe.to_s)
  #
  #  create_user_pagesource = @driver.page_source
  #  create_user_pagesource = create_user_pagesource.to_s
  #  newline_create_user = create_user_pagesource.gsub(/\>/, "\n")
  #
  #  @ary3 = Array.new
  #
  #  matcher_create_user = newline_create_user.scan(/key[0-9]+" label="Manage Users"/)
  #
  #  if matcher_create_user.size > 1
  #    matcher_create_user.each do |line|
  #      get_all_create_user = line.scan(/key[0-9]+/)
  #
  #      get_all_create_user.each do |key|
  #        @ary3.push(key)
  #      end
  #
  #    end
  #    get_key_create_user = @ary3[0]
  #
  #  else
  #    get_key_create_user = matcher_create_user[0].scan(/key[0-9]+/)
  #    get_key_create_user = get_key_create_user[0]
  #  end
  #
  #
  #  @driver.action.click(@driver.find_element(:xpath, '//*[@id="'+get_key_create_user+'"]')).perform
  #  sleep 5
  #
  #  list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  get_main_iframe = list_main_iframe[2]
  #  @driver.switch_to.frame(get_main_iframe)
  #
  #  main_content_pagesource = @driver.page_source
  #  main_content_pagesource = main_content_pagesource.to_s
  #  newline_main_content = main_content_pagesource.gsub(/\>/, "\n")
  #
  #  manage_user_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  manage_user_iframe = manage_user_iframe[0]
  #  @driver.switch_to.frame(manage_user_iframe)
  #
  #  name = @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchName').send_key('Nuttapon')
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
  #
  #  sleep 15
  #
  #
  #  #if matcher
  #  #  #puts x
  #  #  key = x.scan(/key[0-9]+/)
  #  #  puts key.size
  #  #end
  #
  #
  #  #if key.size > 1
  #  #  key.each do |y|
  #  #    count = 1
  #  #    if count == 1
  #  #
  #  #      ### DO NOTHING
  #  #    else
  #  #
  #  #      puts y[1]
  #  #
  #  #    end
  #  #    count = count + 1
  #  #  end
  #  #
  #  #end
  #
  #
  #
  #
  #
  #
  #  #find_treenode = @driver.find_element(:xpath => '//*[@title="Members for CPBI"]').send_keys :arrow_down
  #  #sleep 15
  #
  #  #tree_pagesource2 = @driver.page_source
  #  #matches_frame_border[1 .. matches_frame_border.length].each do |x|
  #  #  puts x.text
  #  #
  #  #end
  #
  #
  #  #reg = /iframe id="[a-z]+[0-9]+"/
  #  #matches = reg.match(tree_pagesource)
  #  #matches[1 .. matches.length].each do |x|
  #  #
  #  #end
  #  #@driver.switch_to.frame(@driver.find_elements(:tag_name => 'iframe').find_index(2))
  #  #tree_pagesource = @driver.page_source
  #
  #  #tree_pagesource2 = tree_pagesource.gsub(/frameborder="0" /, '')
  #
  #  #reg = /iframe id="[a-z]+[0-9]+"/
  #  #matches = reg.match(tree_pagesource)
  #  #matches[1 .. matches.length].each do |x|
  #  #  if x == 4
  #  #    return x.text()
  #  #  end
  #  #end
  #  #iframe_tree = x.text().match(/[a-z]+[0-9]+/)
  #
  #  #index = tree_pagesource2.to_s.match(/iframe id="[a-z]+[0-9]+"/)
  #
  #  #iframe_tree = index[2].match(/[a-z]+[0-9]+/)
  #
  #  #test = @driver.find_elements(:tag_name => 'iframe')
  #  #test.each do |y|
  #  #  puts y
  #  #  #@driver.action.double_click(x).perform
  #  #end
  #  #test = @driver.find_elements(:tag_name, 'html')
  #  #test.each do |x|
  #  #puts x.text()
  #  #@driver.action.double_click(x).perform
  #  #end
  #  #cpbi_member = @driver.find_element(:xpath => '//*[@title="Members for CPBI"]')
  #
  #
  #end

  # Check Tool & Resources box, Members, News
  def assert_three_main_boxes

    tool_resources = @driver.find_element(:css => '.widget-box.edge-frame.purple')
    assert_not_nil(tool_resources, 'Not Found - Tool & Resources box')

    members = @driver.find_element(:css => '.widget-box.edge-frame.darkgreen')
    assert_not_nil(members, 'Not Found - Members box')

    news = @driver.find_element(:css => '.widget-box.edge-frame.orange')
    assert_not_nil(news, 'Not Found - News box')

  end


######################################
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
      #assert_equal(@driver.title, 'My Account'.encode('UTF-8'), 'The page title does not match')

    else
      fail('NO WIDGET BOX')
    end

  end

######################################
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

######################################
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

######################################
  def element_present?(how, what)
    found = @driver.find_element(how => what)
    if found
      true
    else
      false
    end
  rescue Selenium::WebDriver::Error::NoSuchElementError
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
    @driver.get('http://icra-dev.openface.com/Composite/top.aspx')
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

    #membership_cost = @driver.find_element(:xpath => '//*[@id="invoicePanel"]/div[1]/div/div[2]').text
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

end
