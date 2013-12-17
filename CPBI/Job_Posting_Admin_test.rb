require 'test/unit'
require 'test/unit'
require 'selenium-webdriver'
#require '../CPBI/homepage_test'
#require_relative '../CPBI/homepage_test'
require_relative 'cpbi_lib.rb'

class JobPostingAdmin < Test::Unit::TestCase

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

    puts 'Ended - Search Job Posting BackEnd'

  end

  def test_Create_Job_Posting_BackEnd
    # To change this template use File | Settings | File Templates.
    puts 'Starting - Create Job Posting BackEnd'

    @cpbi_backend.login_backend
    sleep 20
    @iframe = @cpbi_backend.select_iframeid

    @wait.until {@driver.find_element(:id => @iframe)}

    @driver.switch_to.frame(@iframe.to_s)

    @cpbi_backend.create_job_posting

    list_main_iframe = @driver.find_elements(:tag_name => 'iframe')
    get_main_iframe = list_main_iframe[2]
    @driver.switch_to.frame(get_main_iframe)

    list_job_posting_iframe = @driver.find_elements(:tag_name => 'iframe')
    manage_job_posting_iframe = list_job_posting_iframe[0]
    @driver.switch_to.frame(manage_job_posting_iframe)

    ##### Assert Manage Job Posting Page #####
    assert_equal('Create new Job Postings'.encode('UTF-8'), @driver.find_element(:tag_name => 'h1').text, 'Create new Job Posting Page NOT FOUND')


  end

  def random_username
    randx = Random.new(100)
    random_number = (randx.rand * 20000).round
    return 'QA '+random_number.to_s
  end

end