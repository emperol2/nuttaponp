require 'test/unit'
require 'test/unit'
require 'selenium-webdriver'
#require '../CPBI/homepage_test'
#require_relative '../CPBI/homepage_test'
require_relative 'cpbi_lib.rb'

class BackEnd < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.

  def setup
    # Create Object from CPBI Library (cpbi_lib.rb)
    @cpbi_backend = CPBI_backend.new
    @driver = @cpbi_backend.driver
    @wait = @cpbi_backend.wait
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    @driver.quit()
  end

  # Fake test
  #def test_Search_User_BackEnd
  #
  #  # To change this template use File | Settings | File Templates.
  #  puts 'Starting - Normal Search User Back End'
  #  @cpbi_backend.login_backend
  #
  #  sleep 20
  #
  #  @iframe = @cpbi_backend.select_iframeid
  #
  #  @wait.until {@driver.find_element(:id => @iframe)}
  #
  #  #puts @iframe.to_s
  #  @driver.switch_to.frame(@iframe.to_s)
  #
  #  @cpbi_backend.manage_user
  #
  #  list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  get_main_iframe = list_main_iframe[2]
  #  @driver.switch_to.frame(get_main_iframe)
  #
  #  #main_content_pagesource = @driver.page_source
  #  #main_content_pagesource = main_content_pagesource.to_s
  #  #newline_main_content = main_content_pagesource.gsub(/\>/, ">\r\n")
  #
  #  manage_user_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  manage_user_iframe = manage_user_iframe[0]
  #  @driver.switch_to.frame(manage_user_iframe)
  #
  #  ##### Assert Empty and Find from UserID #####
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('Nuttapon')
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
  #
  #  sleep 10
  #
  #  get_total_number = @driver.find_element(:class => 'record-count').text
  #
  #  #assert(get_total_number.scan(/Total number of records found: [1-9][0-9]+/), 'Number of records not found')
  #  assert_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')
  #
  #  ##### Assert Not Empty and Find from UserID #####
  #  @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('20041')
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
  #
  #  sleep 10
  #
  #  get_total_number = @driver.find_element(:class => 'record-count').text
  #  assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')
  #
  #  puts 'Ended - Normal Search User Back End'
  #
  #end
  #
  #def test_Create_User_BackEnd
  #
  #  puts 'Starting - Create User Back End'
  #  @cpbi_backend.login_backend
  #
  #  sleep 20
  #
  #  @iframe = @cpbi_backend.select_iframeid
  #
  #  @wait.until {@driver.find_element(:id => @iframe)}
  #
  #  #puts @iframe.to_s
  #  @driver.switch_to.frame(@iframe.to_s)
  #
  #  @cpbi_backend.create_user
  #
  #  list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  get_main_iframe = list_main_iframe[2]
  #  @driver.switch_to.frame(get_main_iframe)
  #
  #  #main_content_pagesource = @driver.page_source
  #  #main_content_pagesource = main_content_pagesource.to_s
  #  #newline_main_content = main_content_pagesource.gsub(/\>/, ">\r\n")
  #
  #  manage_user_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  manage_user_iframe = manage_user_iframe[0]
  #  @driver.switch_to.frame(manage_user_iframe)
  #
  #  #############################################
  #  ########## CREATE NEW REGULAR MEMBER ########
  #  #############################################
  #
  #  ##### Select Regular membership class and Fill all information #####
  #
  #  get_regular_class = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_rptMembershipClass_ctl01_rdoMembershipClass').click
  #  sleep 5
  #  salutation = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_ddlSalutation_ddlLookupData')
  #  get_salutation = salutation.find_elements(:tag_name => 'option')
  #  get_salutation.each do |option|
  #    if option.text == 'Mr.'.encode('UTF-8')
  #      option.click
  #    end
  #  end
  #
  #  @first_name = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtFirstName').send_key(random_username)
  #  last_name = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtLastName').send_key('Automation')
  #  email = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtEmail').send_key('qa@openface.com')
  #
  #  yob = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ddlBirthYear')
  #  get_yob = yob.find_elements(:tag_name => 'option')
  #  get_yob.each do |option|
  #    if option.text == '1985'.encode('UTF-8')
  #      option.click
  #    end
  #
  #  end
  #
  #  title = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtTitle').send_key('Quality Assurance')
  #  employer = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtEmployer').send_key('Openface')
  #
  #  country = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_ddlCountry')
  #  get_country = country.find_elements(:tag_name => 'option')
  #  #get_country.each do |option|
  #  #  if option.text == 'Canada'.encode('UTF-8')
  #  #    option.click
  #  #  end
  #  #end
  #  get_country[1].click
  #
  #  sleep 5
  #
  #  #@driver.execute_script("document.getElementById('ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtAddress1').focus();");
  #
  #  address = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtAddress1').send_key('123/345 Openface Thailand')
  #  city = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtCity').send_key('Atlantic')
  #
  #  province = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_ddlProvince')
  #  get_province = province.find_elements(:tag_name => 'option')
  #  #get_province.each do |option|
  #  #  if option.text == 'Prince Edward Island'.encode('UTF-8')
  #  #    option.click
  #  #  end
  #  #
  #  #end
  #  get_province[10].click
  #
  #  sleep 5
  #
  #  postal = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtPostalCode').send_key('T1T 1T1')
  #  phone = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtPhone').send_key('0819882642')
  #
  #  ######################################################
  #  ##### Sector, Plan Sponsor and Specialty #####
  #  ######################################################
  #  select_plan_sponsor = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlMemberAttributeEditor_rdoSectorPlanSponsor').click
  #
  #  plan_sponsor = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlMemberAttributeEditor_ddlSectorPlanSponsor')
  #  get_plan_sponsor = plan_sponsor.find_elements(:tag_name => 'option')
  #  get_plan_sponsor.each do |plan_option|
  #    if plan_option.text == 'Government'.encode('UTF-8')
  #      plan_option.click
  #    end
  #  end
  #
  #  specialty = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlMemberAttributeEditor_ddlSectorSpecialty')
  #  get_specialty = specialty.find_elements(:tag_name => 'option')
  #  get_specialty.each do |specialty_option|
  #    if specialty_option.text == 'Information Technology'.encode('UTF-8')
  #      specialty_option.click
  #    end
  #  end
  #
  #  check_agree = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_chkAgree').click
  #  check_confirmation = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_chkSendConfirmation').click
  #
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_btnSave').click
  #
  #
  #  #@driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('Nuttapon')
  #  #@driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
  #  #
  #  #sleep 10
  #  #
  #  #get_total_number = @driver.find_element(:class => 'record-count').text
  #  #
  #  ##assert(get_total_number.scan(/Total number of records found: [1-9][0-9]+/), 'Number of records not found')
  #  #assert_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')
  #  #
  #  ###### Assert Not Empty and Find from UserID #####
  #  #@driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click
  #  #@driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('20041')
  #  #@driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
  #  #
  #  #sleep 10
  #  #
  #  #get_total_number = @driver.find_element(:class => 'record-count').text
  #  #assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')
  #
  #  puts 'Ended - Create User Back End'
  #
  #end
  #
  #def test_Search_User_After_Created_BackEnd
  #
  #  # To change this template use File | Settings | File Templates.
  #
  #  # Create Object from CPBI Library (cpbi_lib.rb)
  #  #cpbi_backend = CPBI_backend.new
  #  #@driver = cpbi_backend.driver
  #  #@wait = cpbi_backend.wait
  #  puts 'Starting - Search User After Created Back End'
  #  @cpbi_backend.login_backend
  #
  #  sleep 20
  #
  #  @iframe = @cpbi_backend.select_iframeid
  #
  #  @wait.until {@driver.find_element(:id => @iframe)}
  #
  #  #puts @iframe.to_s
  #  @driver.switch_to.frame(@iframe.to_s)
  #
  #  @cpbi_backend.manage_user
  #
  #  list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  get_main_iframe = list_main_iframe[2]
  #  @driver.switch_to.frame(get_main_iframe)
  #
  #  #main_content_pagesource = @driver.page_source
  #  #main_content_pagesource = main_content_pagesource.to_s
  #  #newline_main_content = main_content_pagesource.gsub(/\>/, ">\r\n")
  #
  #  manage_user_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  manage_user_iframe = manage_user_iframe[0]
  #  @driver.switch_to.frame(manage_user_iframe)
  #
  #  ##### Assert Empty and Find from UserID #####
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key(random_username)
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
  #
  #  sleep 10
  #
  #  get_total_number = @driver.find_element(:class => 'record-count').text
  #
  #  #assert(get_total_number.scan(/Total number of records found: [1-9][0-9]+/), 'Number of records not found')
  #  assert_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')
  #
  #  ##### Assert Not Empty and Find from UserID #####
  #  @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('20041')
  #  @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
  #
  #  sleep 10
  #
  #  get_total_number = @driver.find_element(:class => 'record-count').text
  #  assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')
  #
  #  puts 'Ended - Search User After Created Back End'
  #
  #end

  def test_Search_Job_Posting_BackEnd

    # To change this template use File | Settings | File Templates.
    puts 'Starting - Manage Job Posting BackEnd'

    @cpbi_backend.login_backend
    sleep 20
    @iframe = @cpbi_backend.select_iframeid

    @wait.until {@driver.find_element(:id => @iframe)}

    @driver.switch_to.frame(@iframe.to_s)

    @cpbi_backend.manage_job_posting

    list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_main_iframe = list_main_iframe[2]
    @driver.switch_to.frame(get_main_iframe)

    list_job_posting_iframe = @driver.find_elements(:tag_name => 'iframe')
    manage_job_posting_iframe = list_job_posting_iframe[0]
    @driver.switch_to.frame(manage_job_posting_iframe)

    ##### Assert Manage Job Posting Page #####
    assert_equal('Manage Job Postings'.encode('UTF-8'), @driver.find_element(:tag_name => 'h1').text, 'Job Posting Page NOT FOUND')

    ##### Search by Posting ID #####
    job_posting_number = '80043'.to_s
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_txtPostingId').send_keys job_posting_number
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_btnSearch').click
    sleep 10
    get_total_job_number = @driver.find_element(:class => 'record-count').text
    assert_empty(get_total_job_number.scan(/Total number of records found: [0]/), 'Number of records not found')
    assert_equal(job_posting_number, @driver.find_element(:id => 'ctl00_MPContent_ctlJobPostingsList_grdJobPostings_ctl02_LinkButton1').text, 'Number of record does not match')

    @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click

    ##### Search by Position Title #####
    position_title_wildcard = '%mana%'.to_s
    position_title_normal = 'manager'.to_s

    ##### Search by Position title with Wildcard #####
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_txtPositionTitle').send_keys position_title_wildcard
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_btnSearch').click
    sleep 10
    get_total_job_number = @driver.find_element(:class => 'record-count').text
    assert_empty(get_total_job_number.scan(/Total number of records found: [0]/), 'Number of records not found')
    get_all_td = @driver.find_elements(:tag_name => 'td')
    td_col = nil
    get_all_td.each do |td_col|
      get_td = td_col.text
      if get_td.scan(/[M-m]anager/).empty? == false
        assert_equal('Manager'.encode('UTF-8'), get_td, 'Number of record does not match')
      end
    end

    @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click

    ##### Search by Position title without Wildcard #####
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_txtPositionTitle').send_keys position_title_normal
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_btnSearch').click
    sleep 10
    get_total_job_number = @driver.find_element(:class => 'record-count').text
    assert_empty(get_total_job_number.scan(/Total number of records found: [0]/), 'Number of records not found')
    get_all_td = @driver.find_elements(:tag_name => 'td')
    td_col = nil
    get_all_td.each do |td_col|
      get_td = td_col.text
      if get_td.scan(/[M-m]anager/).empty? == false
        assert_equal('Manager'.encode('UTF-8'), get_td, 'Number of record does not match')
      end
    end
    @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click

    ##### Search by Organization #####
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_txtOrganization').send_keys 'Adecco'
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_btnSearch').click
    sleep 10
    get_total_job_number = @driver.find_element(:class => 'record-count').text
    assert_empty(get_total_job_number.scan(/Total number of records found: [0]/), 'Number of records not found')
    get_all_td = @driver.find_elements(:tag_name => 'td')
    td_col = nil
    get_all_td.each do |td_col|
      get_td = td_col.text
      if get_td.scan(/[A-a]decco/).empty? == false
        assert_equal('Adecco'.encode('UTF-8'), get_td, 'Number of record does not match')
      end
    end



    ###### Assert Empty and Find from UserID #####
    #@driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('Nuttapon')
    #@driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
    #
    #sleep 10
    #
    #get_total_number = @driver.find_element(:class => 'record-count').text
    #
    ##assert(get_total_number.scan(/Total number of records found: [1-9][0-9]+/), 'Number of records not found')
    #assert_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')
    #
    ###### Assert Not Empty and Find from UserID #####
    #@driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click
    #@driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('20041')
    #@driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click
    #
    #sleep 10
    #
    #get_total_number = @driver.find_element(:class => 'record-count').text
    #assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')

    puts 'Ended - Manage Job Posting BackEnd'

  end


  def random_username

    randx = Random.new(100)
    random_number = (randx.rand * 20000).round
    return 'QA '+random_number.to_s

  end

end