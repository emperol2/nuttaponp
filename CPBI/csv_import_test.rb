require 'test/unit'
require 'test/unit'
require 'selenium-webdriver'
require 'csv'
require_relative 'cpbi_lib.rb'

class CSV_Import < Test::Unit::TestCase

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

  def test_Import_Job_Posting_BackEnd
    # To change this template use File | Settings | File Templates.
    puts 'Starting - Import Job Posting BackEnd'

    clear()

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
    assert_equal('Create new Job Posting'.encode('UTF-8'), @driver.find_element(:tag_name => 'h1').text, 'Create new Job Posting Page NOT FOUND')

    data_import = csv_import

    data_import.each do |each_data|
      name = each_data['name']
      surname = each_data['surname']
      no1 = each_data['no1']
      no2 = each_data['no2']

      get_app_status_obj = @driver.find_element(:id => 'ctl00_MPContent_ctlJobPostingEditor_ddlApprovalStatus_ddlLookupData')
      get_app_status = get_app_status_obj.find_elements(:tag_name => 'option')
      get_app_status.each do |option|
        if option.text == 'Approved'
          option.click
        end
      end

      @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_txtOrganization').send_keys 'Organization '+name
      @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_txtPosition').send_keys 'Position '+surname
      @cpbi_backend.dropdown2value('ctl00_MPContent_ctlJobPostingEditor_ddlProvince', 'Alberta')
      @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_txtLocation').send_keys 'Canada '+no1
      @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_dtpJobStartDate_txtDatePicker').click

      time = Time.new
      @driver.find_element(:link => time.day).click
      @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_rteDescription').click
      @driver.switch_to.default_content
      get_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_iframe[0])
      get_all_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_all_desc_iframe[0])
      get_top_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_top_desc_iframe[0])
      get_content_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_content_desc_iframe[0])
      get_editor_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_editor_desc_iframe[0])


      @cpbi_backend.select('tinymce').send_keys 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ut auctor enim. Aenean nec lectus fringilla, pretium lacus nec, sodales ipsum. Vestibulum aliquam ipsum a lacus semper posuere.'
      @driver.switch_to.default_content
      get_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_iframe[0])
      get_all_desc_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_all_desc_iframe[0])
      @cpbi_backend.select('buttonAccept').click

      get_iframe = nil
      get_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_iframe[0])

      get_right_iframe = nil
      get_right_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_right_iframe[2])

      get_main_iframe = nil
      get_main_iframe = @driver.find_elements(:tag_name => 'iframe')
      @driver.switch_to.frame(get_main_iframe[0])

      @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_txtJobWebsite').send_keys 'www.google.com'
      @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_btnSave').click
      sleep 5

      @cpbi_backend.select('ctl00_MPContent_ctlJobPostingEditor_btnCancel').click
      sleep 3

      @cpbi_backend.select('ctl00_MPFooter_btnCreateNew').click
    end

    puts 'Ending - Import Job Posting BackEnd'

  end

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

  def csv_import
    csv = CSV.read('c:/test.csv', :headers => true)

  end

end