require 'test/unit'
require 'test/unit'
require 'selenium-webdriver'
require 'csv'
#require '../CPBI/homepage_test'
#require_relative '../CPBI/homepage_test'
require_relative 'cpbi_lib.rb'

class JobPostingAdmin < Test::Unit::TestCase
  @@random_num = nil

  # Called before every test method runs. Can be used
  # to set up fixture information.

  def setup
    # Create Object from CPBI Library (cpbi_lib.rb)
    @cpbi_backend = CPBI_backend.new
    @driver = @cpbi_backend.driver
    @wait = @cpbi_backend.wait
    @verification_errors = []
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    @driver.quit()
    @verification_errors
  end

  def test_Search_Job_Posting_BackEnd

    # To change this template use File | Settings | File Templates.
    puts 'Starting - Search Job Posting BackEnd'

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
    assert_equal('Manage Job Postings'.encode('UTF-8'), @driver.find_element(:tag_name => 'h1').text, 'Manage Job Posting Page NOT FOUND')

    ##### Search by Posting ID #####
    job_posting_number = '80043'.to_s
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_txtPostingId').send_keys job_posting_number
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_btnSearch').click
    sleep 10
    get_total_job_number = @driver.find_element(:class => 'record-count').text

    @cpbi_backend.verify { assert_empty(get_total_job_number.scan(/Total number of records found: [0]/), 'Number of records not found') }
    @cpbi_backend.verify { assert_equal(job_posting_number, @driver.find_element(:id => 'ctl00_MPContent_ctlJobPostingsList_grdJobPostings_ctl02_LinkButton1').text, 'Number of record does not match') }

    @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click

    ##### Search by Position Title #####
    position_title_wildcard = '%mana%'.to_s
    position_title_normal = 'manager'.to_s

    ##### Search by Position title with Wildcard #####
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_txtPositionTitle').send_keys position_title_wildcard
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_btnSearch').click
    sleep 10
    get_total_job_number = @driver.find_element(:class => 'record-count').text
    @cpbi_backend.verify { assert_empty(get_total_job_number.scan(/Total number of records found: [0]/), 'Number of records not found') }
    get_all_td = @driver.find_elements(:tag_name => 'td')
    td_col = nil
    get_all_td.each do |td_col|
      get_td = td_col.text
      if get_td.scan(/[M-m]anager/).empty? == false
        @cpbi_backend.verify { assert_equal('Manager'.encode('UTF-8'), get_td, 'Number of record does not match') }
      end
    end

    @driver.find_element(:id => 'ctl00_MPFooter_btnNewSearch').click

    ##### Search by Position title without Wildcard #####
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_txtPositionTitle').send_keys position_title_normal
    @driver.find_element(:id => 'ctl00_MPContent_ctlSearchFilter_btnSearch').click
    sleep 10
    get_total_job_number = @driver.find_element(:class => 'record-count').text
    @cpbi_backend.verify { assert_empty(get_total_job_number.scan(/Total number of records found: [0]/), 'Number of records not found') }
    get_all_td = @driver.find_elements(:tag_name => 'td')
    td_col = nil
    get_all_td.each do |td_col|
      get_td = td_col.text
      if get_td.scan(/[M-m]anager/).empty? == false
        @cpbi_backend.verify { assert_equal('Manager'.encode('UTF-8'), get_td, 'Number of record does not match') }
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

    puts 'Ended - Search Job Posting BackEnd'

  end

  #def test_Create_Job_Posting_BackEnd
  #  # To change this template use File | Settings | File Templates.
  #  puts 'Starting - Create Job Posting BackEnd'
  #
  #  clear()
  #
  #  @cpbi_backend.login_backend
  #  sleep 20
  #  @iframe = @cpbi_backend.select_iframeid
  #
  #  @wait.until {@driver.find_element(:id => @iframe)}
  #
  #  @driver.switch_to.frame(@iframe.to_s)
  #
  #  @cpbi_backend.create_job_posting
  #
  #  list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  get_main_iframe = list_main_iframe[2]
  #  @driver.switch_to.frame(get_main_iframe)
  #
  #  list_job_posting_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  manage_job_posting_iframe = list_job_posting_iframe[0]
  #  @driver.switch_to.frame(manage_job_posting_iframe)
  #
  #  ##### Assert Manage Job Posting Page #####
  #  assert_equal('Create new Job Posting'.encode('UTF-8'), @driver.find_element(:tag_name => 'h1').text, 'Create new Job Posting Page NOT FOUND')
  #
  #  get_app_status_obj = @driver.find_element(:id => 'ctl00_MPContent_ctlJobPostingEditor_ddlApprovalStatus_ddlLookupData')
  #  get_app_status = get_app_status_obj.find_elements(:tag_name => 'option')
  #  get_app_status.each do |option|
  #    if option.text == 'Approved'
  #      option.click
  #    end
  #  end
  #
  #  @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_txtOrganization').send_keys 'Organization '+random_number
  #  @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_txtPosition').send_keys 'Position '+random_number
  #  @cpbi_backend.dropdown2value('ctl00_MPContent_ctlJobPostingEditor_ddlProvince', 'Alberta')
  #  @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_txtLocation').send_keys 'Canada '+random_number
  #  @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_dtpJobStartDate_txtDatePicker').click
  #  #@wait.until {@driver.find_element(:id => 'ui-datepicker-div')}
  #  #@cpbi_backend.select(':class', 'a.ui-state-default.ui-state-highlight').click
  #  time = Time.new
  #  @driver.find_element(:link => time.day).click
  #  @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_rteDescription').click
  #  @driver.switch_to.default_content
  #  get_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_iframe[0])
  #  get_all_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_all_desc_iframe[0])
  #  get_top_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_top_desc_iframe[0])
  #  get_content_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_content_desc_iframe[0])
  #  get_editor_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_editor_desc_iframe[0])
  #
  #  #a = @driver.page_source
  #  #list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  #@iframe = @cpbi_backend.select_iframeid
  #
  #  #@wait.until {@driver.find_element(:id => 'editor_ifr')}
  #  #@driver.switch_to.frame(@driver.find_element(:id => 'editor_ifr'))
  #  @cpbi_backend.select('tinymce').send_keys 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ut auctor enim. Aenean nec lectus fringilla, pretium lacus nec, sodales ipsum. Vestibulum aliquam ipsum a lacus semper posuere.'
  #  @driver.switch_to.default_content
  #  get_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_iframe[0])
  #  get_all_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_all_desc_iframe[0])
  #  @cpbi_backend.select('buttonAccept').click
  #
  #  get_iframe = nil
  #  get_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_iframe[0])
  #
  #  get_right_iframe = nil
  #  get_right_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_right_iframe[2])
  #
  #  get_main_iframe = nil
  #  get_main_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  @driver.switch_to.frame(get_main_iframe[0])
  #
  #  #a = @driver.page_source
  #  #list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
  #  #@iframe = @cpbi_backend.select_iframeid
  #
  #  @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_txtJobWebsite').send_keys 'www.google.com'
  #  @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_btnSave').click
  #  sleep 5
  #
  #  puts 'Ended - Create Job Posting BackEnd'
  #
  #end

  def random_username
    randx = nil
    randx = Random.new()
    random_number = (randx.rand * 20000).round
    return 'QA '+random_number.to_s
  end

  def random_number
    randx = nil
    randx = Random.new()
    random_number = (randx.rand * 20000).round
    #return 'Organization '+random_number.to_s
    return random_number.to_s
  end

  def clear
    eval %q{ local_variables.each { |e| eval("#{e} = nil") } }
  end

end