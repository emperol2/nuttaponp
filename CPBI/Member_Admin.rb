require 'test/unit'
require 'selenium-webdriver'
#require '../CPBI/homepage_test'
#require_relative '../CPBI/homepage_test'
require_relative 'cpbi_lib.rb'

class Member_Admin < Test::Unit::TestCase

  @@rand_user = nil
  @@random_number  = nil

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Create Object from CPBI Library (cpbi_lib.rb)
    @cpbi_backend = CPBI_lib.new
    @driver = @cpbi_backend.driver
    @wait = @cpbi_backend.wait
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    @driver.quit()
  end

  def test_A_Search_User_BackEnd
    # To change this template use File | Settings | File Templates.
    puts 'Starting - Normal Search User Back End'
    @cpbi_backend.login_backend
    sleep 10

    @iframe = @cpbi_backend.select_iframeid
    @wait.until { @driver.find_element(:id => @iframe) }
    @driver.switch_to.frame(@iframe.to_s)

    # Calls control_user method with Manage Users
    @cpbi_backend.control_user('Manage Users')

    # Switch to input, get main iframe on right side - then get iframe inside
    switch_to_input_form()

    ##### Search from Name #####
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchName').send_keys 'Lena'
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
    sleep 5
    get_total_number = @driver.find_element(:class => 'record-count').text
    assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Lena is not found in their records')

    ##### Search from user id #####
    @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_keys '0008'
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
    sleep 5
    get_total_number = @driver.find_element(:class => 'record-count').text
    assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'ID of record is not found')

    puts 'Ended - Normal Search User Back End'

  end

  def test_B_Create_User_BackEnd
    puts 'Starting - Create User Back End'
    @cpbi_backend.login_backend
    sleep 10

    @iframe = @cpbi_backend.select_iframeid
    @wait.until { @driver.find_element(:id => @iframe) }
    @driver.switch_to.frame(@iframe.to_s)

    # Calls control user method, with create user functionality
    @cpbi_backend.control_user('Create User')

    # Switch to input, get main iframe on right side - then get iframe inside
    switch_to_input_form()

    #############################################
    ########## CREATE NEW REGULAR MEMBER ########
    #############################################

    ##### Select Regular membership class and Fill all information #####
    get_regular_class = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_rptMembershipClass_ctl00_rdoMembershipClass').click
    sleep 5
    salutation = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_ddlSalutation_ddlLookupData')
    get_salutation = salutation.find_elements(:tag_name => 'option')
    get_salutation.each do |option|
      if option.text == 'Mr.'.encode('UTF-8')
        option.click
      end
    end

    @first_name = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtFirstName').send_keys random_username
    last_name = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtLastName').send_key('Automation')
    email = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtEmail').send_keys 'qa' + @@random_number + '@openface.com'
    yob = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ddlBirthYear')
    get_yob = yob.find_elements(:tag_name => 'option')
    get_yob.each do |option2|
      if option2.text == '1985'.encode('UTF-8')
        option2.click
      end
    end

    title = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtTitle').send_key('Quality Assurance')
    employer = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtEmployer').send_key('Openface')
    country = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_ddlCountry')
    get_country = country.find_elements(:tag_name => 'option')
    get_country[1].click
    sleep 5

    address = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtAddress1').send_key('123/345 Openface Thailand')
    city = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtCity').send_key('Atlantic')
    province = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_ddlProvince')
    get_province = province.find_elements(:tag_name => 'option')
    get_province[10].click
    sleep 5

    postal = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtPostalCode').send_key('T1T 1T1')
    phone = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtPhone').send_key('0819882642')

    ######################################################
    ##### Sector, Plan Sponsor and Specialty #####
    ######################################################
    select_plan_sponsor = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlMemberAttributeEditor_rdoSectorPlanSponsor').click
    plan_sponsor = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlMemberAttributeEditor_ddlSectorPlanSponsor')
    get_plan_sponsor = plan_sponsor.find_elements(:tag_name => 'option')
    get_plan_sponsor.each do |plan_option|
      if plan_option.text == 'Government'.encode('UTF-8')
        plan_option.click
      end
    end

    specialty = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlMemberAttributeEditor_ddlSectorSpecialty')
    get_specialty = specialty.find_elements(:tag_name => 'option')
    get_specialty.each do |specialty_option|
      if specialty_option.text == 'Information Technology'.encode('UTF-8')
        specialty_option.click
      end
    end

    check_agree = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_chkAgree').click
    check_confirmation = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_chkSendConfirmation').click

    @driver.find_element(:id => 'ctl00_MPFooter_btnSave').click
    sleep 5

    puts 'Ended - Create User Back End'

  end

  def test_C_Search_User_After_Created_BackEnd
    # skip "skip this test"
    puts 'Starting - Search User After Created Back End'
    @cpbi_backend.login_backend
    sleep 10

    @iframe = @cpbi_backend.select_iframeid
    @wait.until { @driver.find_element(:id => @iframe) }
    @driver.switch_to.frame(@iframe.to_s)

    # Calls control_user method with Manage Users
    @cpbi_backend.control_user('Manage Users')

    # Switch to input, get main iframe on right side - then get iframe inside
    switch_to_input_form()

    ##### Assert Empty and Find from UserID #####
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchName').send_keys @@rand_user
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
    sleep 5
    get_total_number = @driver.find_element(:class => 'record-count').text
    assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')

    ##### Assert Not Empty and Find from UserID #####
    @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_keys('0001')
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
    sleep 5
    get_total_number = @driver.find_element(:class => 'record-count').text
    assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')

    puts 'Ended - Search User After Created Back End'

  end

  ########## Method ##########

  def random_username
    randx = nil
    randx = Random.new()
    @@random_number = (randx.rand * 20000).round
    @@random_number = @@random_number.to_s
    @@rand_user = 'QA '+@@random_number.to_s
  end

  def switch_to_input_form
    list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_main_iframe = list_main_iframe[2]
    @driver.switch_to.frame(get_main_iframe)

    manage_user_iframe = @driver.find_elements(:tag_name => 'iframe')
    manage_user_iframe = manage_user_iframe[0]
    @driver.switch_to.frame(manage_user_iframe)
  end

end