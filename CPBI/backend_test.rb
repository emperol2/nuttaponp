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
  def test_Search_User_BackEnd

    # To change this template use File | Settings | File Templates.

    # Create Object from CPBI Library (cpbi_lib.rb)
    #cpbi_backend = CPBI_backend.new
    #@driver = cpbi_backend.driver
    #@wait = cpbi_backend.wait
    puts 'Starting - Normal Search User Back End'
    @cpbi_backend.login_backend

    sleep 20

    @iframe = @cpbi_backend.select_iframeid

    @wait.until {@driver.find_element(:id => @iframe)}

    #puts @iframe.to_s
    @driver.switch_to.frame(@iframe.to_s)

    ####### Switch to explorer frame #######
    list_home_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_explorer_iframe = list_home_iframe[3]
    @driver.switch_to.frame(get_explorer_iframe)

    sleep 5

    ####### Switch to system view (tree) frame #######
    list_system_view_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_system_view_iframe = list_system_view_iframe[0]
    @driver.switch_to.frame(get_system_view_iframe)

    sleep 5

    ####### unwrap page source to each line, and click at 'CPBI Members' tree #######
    tree_pagesource2 = @driver.page_source
    tree_pagesource2 = tree_pagesource2.to_s
    newline_tree = tree_pagesource2.gsub(/\>/, ">\r\n")

    @ary = Array.new
    newline_tree.each_line do |line|

      matcher_member = line.include? 'Members for CPBI'

      if matcher_member

        get_all_member = line.scan(/key[0-9]+/)

        get_all_member.each do |key|
          @ary.push(key)
        end

      end

    end

    #puts get_key_member = @ary[3]
    get_key_member = @ary[3]
    @driver.action.double_click(@driver.find_element(:xpath, '//*[@id="'+get_key_member+'"]')).perform
    sleep 10

    ####### unwrap page source to each line, and click at 'Users' tree #######
    user_pagesource = @driver.page_source
    user_pagesource = user_pagesource.to_s
    newline_user = user_pagesource.gsub(/\>/, ">\r\n")

    @ary2 = Array.new

    matcher_user = newline_user.scan(/key[0-9]+" label="Users"/)

    matcher_user.each do |line|
      get_all_user = line.scan(/key[0-9]+/)

      get_all_user.each do |key|
        @ary2.push(key)
      end

    end

    #puts get_key_user = @ary2[1]
    get_key_user = @ary2[1]
    @driver.action.click(@driver.find_element(:xpath, '//*[@id="'+get_key_user+'"]')).perform
    sleep 10

    @driver.switch_to.default_content

    @cpbi_backend.select_iframeid()

    @driver.switch_to.frame(@iframe.to_s)

    create_user_pagesource = @driver.page_source
    create_user_pagesource = create_user_pagesource.to_s
    newline_create_user = create_user_pagesource.gsub(/\>/, ">\r\n")

    @ary3 = Array.new

    matcher_create_user = newline_create_user.scan(/key[0-9]+" label="Manage Users"/)

    if matcher_create_user.size > 1
      matcher_create_user.each do |line|
        get_all_create_user = line.scan(/key[0-9]+/)

        get_all_create_user.each do |key|
          @ary3.push(key)
        end

      end
      get_key_create_user = @ary3[0]

    else
      get_key_create_user = matcher_create_user[0].scan(/key[0-9]+/)
      get_key_create_user = get_key_create_user[0]
    end


    @driver.action.click(@driver.find_element(:xpath, '//*[@id="'+get_key_create_user+'"]')).perform
    sleep 10

    list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_main_iframe = list_main_iframe[2]
    @driver.switch_to.frame(get_main_iframe)

    #main_content_pagesource = @driver.page_source
    #main_content_pagesource = main_content_pagesource.to_s
    #newline_main_content = main_content_pagesource.gsub(/\>/, ">\r\n")

    manage_user_iframe = @driver.find_elements(:tag_name => 'iframe')
    manage_user_iframe = manage_user_iframe[0]
    @driver.switch_to.frame(manage_user_iframe)

    ##### Assert Empty and Find from UserID #####
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('Nuttapon')
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click

    sleep 10

    get_total_number = @driver.find_element(:class => 'record-count').text

    #assert(get_total_number.scan(/Total number of records found: [1-9][0-9]+/), 'Number of records not found')
    assert_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')

    ##### Assert Not Empty and Find from UserID #####
    @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('20041')
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click

    sleep 10

    get_total_number = @driver.find_element(:class => 'record-count').text
    assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')

    puts 'Ended - Normal Search User Back End'


  end

  def test_Create_User_BackEnd

    # To change this template use File | Settings | File Templates.

    # Create Object from CPBI Library (cpbi_lib.rb)
    #cpbi_backend = CPBI_backend.new
    #@driver = cpbi_backend.driver
    #@wait = cpbi_backend.wait
    puts 'Starting - Create User Back End'
    @cpbi_backend.login_backend

    sleep 20

    @iframe = @cpbi_backend.select_iframeid

    @wait.until {@driver.find_element(:id => @iframe)}

    #puts @iframe.to_s
    @driver.switch_to.frame(@iframe.to_s)

    ####### Switch to explorer frame #######
    list_home_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_explorer_iframe = list_home_iframe[3]
    @driver.switch_to.frame(get_explorer_iframe)

    sleep 5

    ####### Switch to system view (tree) frame #######
    list_system_view_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_system_view_iframe = list_system_view_iframe[0]
    @driver.switch_to.frame(get_system_view_iframe)

    sleep 5

    ####### unwrap page source to each line, and click at 'CPBI Members' tree #######
    tree_pagesource2 = @driver.page_source
    tree_pagesource2 = tree_pagesource2.to_s
    newline_tree = tree_pagesource2.gsub(/\>/, ">\r\n")

    @ary = Array.new
    newline_tree.each_line do |line|

      matcher_member = line.include? 'Members for CPBI'

      if matcher_member

        get_all_member = line.scan(/key[0-9]+/)

        get_all_member.each do |key|
          @ary.push(key)
        end

      end

    end

    #puts get_key_member = @ary[3]
    get_key_member = @ary[3]
    @driver.action.double_click(@driver.find_element(:xpath, '//*[@id="'+get_key_member+'"]')).perform
    sleep 10

    ####### unwrap page source to each line, and click at 'Users' tree #######
    user_pagesource = @driver.page_source
    user_pagesource = user_pagesource.to_s
    newline_user = user_pagesource.gsub(/\>/, ">\r\n")

    @ary2 = Array.new

    matcher_user = newline_user.scan(/key[0-9]+" label="Users"/)

    matcher_user.each do |line|
      get_all_user = line.scan(/key[0-9]+/)

      get_all_user.each do |key|
        @ary2.push(key)
      end

    end

    #puts get_key_user = @ary2[1]
    get_key_user = @ary2[1]
    @driver.action.click(@driver.find_element(:xpath, '//*[@id="'+get_key_user+'"]')).perform
    sleep 10

    @driver.switch_to.default_content

    @cpbi_backend.select_iframeid()

    @driver.switch_to.frame(@iframe.to_s)

    create_user_pagesource = @driver.page_source
    create_user_pagesource = create_user_pagesource.to_s
    newline_create_user = create_user_pagesource.gsub(/\>/, ">\r\n")

    @ary3 = Array.new

    matcher_create_user = newline_create_user.scan(/key[0-9]+" label="Create User"/)

    if matcher_create_user.size > 1
      matcher_create_user.each do |line|
        get_all_create_user = line.scan(/key[0-9]+/)

        get_all_create_user.each do |key|
          @ary3.push(key)
        end

      end
      get_key_create_user = @ary3[0]

    else
      get_key_create_user = matcher_create_user[0].scan(/key[0-9]+/)
      get_key_create_user = get_key_create_user[0]
    end


    @driver.action.click(@driver.find_element(:xpath, '//*[@id="'+get_key_create_user+'"]')).perform
    sleep 10

    list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_main_iframe = list_main_iframe[2]
    @driver.switch_to.frame(get_main_iframe)

    #main_content_pagesource = @driver.page_source
    #main_content_pagesource = main_content_pagesource.to_s
    #newline_main_content = main_content_pagesource.gsub(/\>/, ">\r\n")

    manage_user_iframe = @driver.find_elements(:tag_name => 'iframe')
    manage_user_iframe = manage_user_iframe[0]
    @driver.switch_to.frame(manage_user_iframe)

    #############################################
    ########## CREATE NEW REGULAR MEMBER ########
    #############################################

    ##### Select Regular membership class and Fill all information #####

    get_regular_class = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_rptMembershipClass_ctl01_rdoMembershipClass').click
    sleep 5
    salutation = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_ddlSalutation_ddlLookupData')
    get_salutation = salutation.find_elements(:tag_name => 'option')
    get_salutation.each do |option|
      if option.text == 'Mr.'.encode('UTF-8')
        option.click
      end
    end

    randx = Random.new(100)
    random_number = (randx.rand * 20000).round
    random_QA = 'QA '+random_number.to_s
    @first_name = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtFirstName').send_key(random_QA)
    last_name = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtLastName').send_key('Automation')
    email = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtEmail').send_key('qa@openface.com')

    yob = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ddlBirthYear')
    get_yob = yob.find_elements(:tag_name => 'option')
    get_yob.each do |option|
      if option.text == '1985'.encode('UTF-8')
        option.click
      end

    end

    title = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtTitle').send_key('Quality Assurance')
    employer = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtEmployer').send_key('Openface')

    country = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_ddlCountry')
    get_country = country.find_elements(:tag_name => 'option')
    #get_country.each do |option|
    #  if option.text == 'Canada'.encode('UTF-8')
    #    option.click
    #  end
    #end
    get_country[1].click

    sleep 5

    #@driver.execute_script("document.getElementById('ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtAddress1').focus();");

    address = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtAddress1').send_key('123/345 Openface Thailand')
    city = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_txtCity').send_key('Atlantic')

    province = @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_ctlAddressEditor_ddlProvince')
    get_province = province.find_elements(:tag_name => 'option')
    #get_province.each do |option|
    #  if option.text == 'Prince Edward Island'.encode('UTF-8')
    #    option.click
    #  end
    #
    #end
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

    @driver.find_element(:id => 'ctl00_MPContent_ctlUserEditor_btnSave').click


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

    puts 'Ended - Create User Back End'

  end

  def test_Search_User_After_Created_BackEnd

    # To change this template use File | Settings | File Templates.

    # Create Object from CPBI Library (cpbi_lib.rb)
    #cpbi_backend = CPBI_backend.new
    #@driver = cpbi_backend.driver
    #@wait = cpbi_backend.wait
    puts 'Starting - Search User After Created Back End'
    @cpbi_backend.login_backend

    sleep 20

    @iframe = @cpbi_backend.select_iframeid

    @wait.until {@driver.find_element(:id => @iframe)}

    #puts @iframe.to_s
    @driver.switch_to.frame(@iframe.to_s)

    ####### Switch to explorer frame #######
    list_home_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_explorer_iframe = list_home_iframe[3]
    @driver.switch_to.frame(get_explorer_iframe)

    sleep 5

    ####### Switch to system view (tree) frame #######
    list_system_view_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_system_view_iframe = list_system_view_iframe[0]
    @driver.switch_to.frame(get_system_view_iframe)

    sleep 5

    ####### unwrap page source to each line, and click at 'CPBI Members' tree #######
    tree_pagesource2 = @driver.page_source
    tree_pagesource2 = tree_pagesource2.to_s
    newline_tree = tree_pagesource2.gsub(/\>/, ">\r\n")

    @ary = Array.new
    newline_tree.each_line do |line|

      matcher_member = line.include? 'Members for CPBI'

      if matcher_member

        get_all_member = line.scan(/key[0-9]+/)

        get_all_member.each do |key|
          @ary.push(key)
        end

      end

    end

    #puts get_key_member = @ary[3]
    get_key_member = @ary[3]
    @driver.action.double_click(@driver.find_element(:xpath, '//*[@id="'+get_key_member+'"]')).perform
    sleep 10

    ####### unwrap page source to each line, and click at 'Users' tree #######
    user_pagesource = @driver.page_source
    user_pagesource = user_pagesource.to_s
    newline_user = user_pagesource.gsub(/\>/, ">\r\n")

    @ary2 = Array.new

    matcher_user = newline_user.scan(/key[0-9]+" label="Users"/)

    matcher_user.each do |line|
      get_all_user = line.scan(/key[0-9]+/)

      get_all_user.each do |key|
        @ary2.push(key)
      end

    end

    #puts get_key_user = @ary2[1]
    get_key_user = @ary2[1]
    @driver.action.click(@driver.find_element(:xpath, '//*[@id="'+get_key_user+'"]')).perform
    sleep 10

    @driver.switch_to.default_content

    @cpbi_backend.select_iframeid()

    @driver.switch_to.frame(@iframe.to_s)

    create_user_pagesource = @driver.page_source
    create_user_pagesource = create_user_pagesource.to_s
    newline_create_user = create_user_pagesource.gsub(/\>/, ">\r\n")

    @ary3 = Array.new

    matcher_create_user = newline_create_user.scan(/key[0-9]+" label="Manage Users"/)

    if matcher_create_user.size > 1
      matcher_create_user.each do |line|
        get_all_create_user = line.scan(/key[0-9]+/)

        get_all_create_user.each do |key|
          @ary3.push(key)
        end

      end
      get_key_create_user = @ary3[0]

    else
      get_key_create_user = matcher_create_user[0].scan(/key[0-9]+/)
      get_key_create_user = get_key_create_user[0]
    end


    @driver.action.click(@driver.find_element(:xpath, '//*[@id="'+get_key_create_user+'"]')).perform
    sleep 10

    list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_main_iframe = list_main_iframe[2]
    @driver.switch_to.frame(get_main_iframe)

    #main_content_pagesource = @driver.page_source
    #main_content_pagesource = main_content_pagesource.to_s
    #newline_main_content = main_content_pagesource.gsub(/\>/, ">\r\n")

    manage_user_iframe = @driver.find_elements(:tag_name => 'iframe')
    manage_user_iframe = manage_user_iframe[0]
    @driver.switch_to.frame(manage_user_iframe)

    ##### Assert Empty and Find from UserID #####
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key(@first_name)
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click

    sleep 10

    get_total_number = @driver.find_element(:class => 'record-count').text

    #assert(get_total_number.scan(/Total number of records found: [1-9][0-9]+/), 'Number of records not found')
    assert_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')

    ##### Assert Not Empty and Find from UserID #####
    @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_txtSearchUsername').send_key('20041')
    @driver.find_element(:id => 'ctl00_MPContent_ctlUserSearchFilter_btnSearch').click

    sleep 10

    get_total_number = @driver.find_element(:class => 'record-count').text
    assert_not_empty(get_total_number.scan(/Total number of records found: [1-9][0-9]*/), 'Number of records not found')

    puts 'Ended - Search User After Created Back End'


  end


end