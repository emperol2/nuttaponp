require 'test/unit'
require 'test/unit'
require 'selenium-webdriver'
#require '../CPBI/homepage_test'
#require_relative '../CPBI/homepage_test'
require_relative 'cpbi_lib.rb'

class BackEnd < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.

  #def setup
  #@driver = Selenium::WebDriver.for :firefox
  #@driver.manage.window.maximize
  #@base_url = 'http://icra-dev/'
  #@driver.manage.timeouts.implicit_wait = 10
  #@wait = Selenium::WebDriver::Wait.new :timeout => 20
  #end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  #def teardown
  #  @driver.quit()
  #end

  # Fake test
  def test_Event_BackEnd

    # To change this template use File | Settings | File Templates.

    # Create Object from CPBI Library (cpbi_lib.rb)
    cpbi_backend = CPBI_backend.new
    @driver = cpbi_backend.driver
    @wait = cpbi_backend.wait
    cpbi_backend.login_backend

    sleep 20

    @iframe = cpbi_backend.select_iframeid

    @wait.until {@driver.find_element(:id => @iframe)}

    #puts @iframe.to_s
    @driver.switch_to.frame(@iframe.to_s)

    ####### Switch to explorer frame #######
    list_home_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_explorer_iframe = list_home_iframe[3]
    @driver.switch_to.frame(get_explorer_iframe)

    ####### Switch to system view (tree) frame #######
    list_system_view_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_system_view_iframe = list_system_view_iframe[0]
    @driver.switch_to.frame(get_system_view_iframe)

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

    cpbi_backend.select_iframeid()

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

    cpbi_backend.quit

  end
end