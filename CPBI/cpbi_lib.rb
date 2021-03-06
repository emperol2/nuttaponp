require 'selenium-webdriver'
require 'rubygems'
require 'test/unit'

class CPBI_lib < Test::Unit::TestCase
  # To change this template use File | Settings | File Templates.
  def initialize
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 10
    @verification_errors = []
  end

  def driver
    @driver
  end

  def wait
    @wait
  end

  def quit
    @driver.quit()
  end

  def login_backend
    # if start from dev site
    @driver.get('http://qa.cpbi-icra.ca/Composite/top.aspx')
    # @driver.get('http://preview.cpbi-icra.ca/Composite/top.aspx')
    @wait.until { @driver.find_element(:css => 'input[name="username"]') }
    @driver.find_element(:css => 'input[name="username"]').send_key('ofsupport')
    @driver.find_element(:css => 'input[name="password"]').send_key('0p3nf4c3')
    @driver.find_element(:css => 'input[name="password"]').send_keys :return
    sleep 80
  end

  # select the first iframe id after logged in Admin site
  def select_iframeid
    storeHtmlSource = @driver.page_source
    storeHtmlSource2 = storeHtmlSource.gsub(/frameborder="0" /, '')
    index = storeHtmlSource2.to_s.match(/iframe id="[a-z]+[0-9]+"/)
    @iframe = index[0].match(/[a-z]+[0-9]+/)
  end

  # select type of user control, such as manage user, create user
  def control_user(where)
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

    get_key_member = @ary[3]
    @driver.action.double_click(@driver.find_element(:xpath, '//*[@id="'+get_key_member+'"]')).perform
    sleep 5

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

    get_key_user = @ary2[1]
    @driver.action.click(@driver.find_element(:xpath, '//*[@id="'+get_key_user+'"]')).perform
    sleep 5

    # back to main iframe id, outermost frame
    @driver.switch_to.default_content
    select_iframeid()
    @driver.switch_to.frame(@iframe.to_s)

    create_user_pagesource = @driver.page_source
    create_user_pagesource = create_user_pagesource.to_s
    newline_create_user = create_user_pagesource.gsub(/\>/, ">\r\n")

    @ary3 = Array.new

    # select Create User or Manage User
    if where == 'Create User'
      matcher_create_user = newline_create_user.scan(/key[0-9]+" label="Create User"/)
    else
      matcher_create_user = newline_create_user.scan(/key[0-9]+" label="Manage Users"/)
    end

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

  end

  def manage_job_posting
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

      matcher_job_posting = line.include? 'Job Postings for CPBI'

      if matcher_job_posting

        get_all_job_posting = line.scan(/key[0-9]+/)

        get_all_job_posting.each do |key|
          @ary.push(key)
        end

      end

    end

    #puts get_key_member = @ary[3]
    get_key_job_posting = @ary[3]
    @driver.action.double_click(@driver.find_element(:xpath, '//*[@id="'+get_key_job_posting+'"]')).perform
    sleep 10

    ####### unwrap page source to each line, and click at 'Users' tree #######
    user_pagesource = @driver.page_source
    user_pagesource = user_pagesource.to_s
    newline_user = user_pagesource.gsub(/\>/, ">\r\n")

    @ary2 = Array.new

    ##### need to inspect the "label" value from html #####
    matcher_user = newline_user.scan(/key[0-9]+" label="Job Postings"/)

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

    select_iframeid()

    @driver.switch_to.frame(@iframe.to_s)

    create_user_pagesource = @driver.page_source
    create_user_pagesource = create_user_pagesource.to_s
    newline_create_user = create_user_pagesource.gsub(/\>/, ">\r\n")

    @ary3 = Array.new

    ##### need to inspect the "label" value from html #####
    matcher_create_user = newline_create_user.scan(/key[0-9]+" label="Manage Job Postings"/)

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

  end

  def create_job_posting
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

      matcher_job_posting = line.include? 'Job Postings for CPBI'

      if matcher_job_posting

        get_all_job_posting = line.scan(/key[0-9]+/)

        get_all_job_posting.each do |key|
          @ary.push(key)
        end

      end

    end

    get_key_job_posting = @ary[3]
    @driver.action.double_click(@driver.find_element(:xpath, '//*[@id="'+get_key_job_posting+'"]')).perform
    sleep 10

    ####### unwrap page source to each line, and click at 'Users' tree #######
    user_pagesource = @driver.page_source
    user_pagesource = user_pagesource.to_s
    newline_user = user_pagesource.gsub(/\>/, ">\r\n")

    @ary2 = Array.new

    ##### need to inspect the "label" value from html #####
    matcher_user = newline_user.scan(/key[0-9]+" label="Job Postings"/)

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

    select_iframeid()

    @driver.switch_to.frame(@iframe.to_s)

    create_user_pagesource = @driver.page_source
    create_user_pagesource = create_user_pagesource.to_s
    newline_create_user = create_user_pagesource.gsub(/\>/, ">\r\n")

    @ary3 = Array.new

    ##### need to inspect the "label" value from html #####
    matcher_create_user = newline_create_user.scan(/key[0-9]+" label="Create Job Posting"/)

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

  end

  def select(where)
    #type = ':'+type
    #where = "'"+where+"'"
    #type = remove_quotations(type)
    @driver.find_element(:id => where)
  end

  def dropdown2value(where, match)
    get_dropdown_obj = select(where)
    get_list = get_dropdown_obj.find_elements(:tag_name => 'option')
    get_list.each do |option|
      if option.text == match.to_s
        option.click
      end
    end
  end

  def remove_quotations(str)
    if str.start_with?('"')
      @str = str.slice(1..-1)
    end
    if str.end_with?('"')
      @str = str.slice(0..-2)
    end
  end

  def verify(&blk)
    yield
  rescue MiniTest::Assertion => ex
    @verification_errors << ex
  end

  def getAnyLocator(*locator)

    str_pattern = /ctl[0-9]*_ctl[0-9]*_phContent_ctl[0-9]*_ctl/
    pageSource = @driver.page_source.to_s
    splitToNewline = pageSource.gsub(/\>/, ">\r\n")

    splitToNewline.each_line do |line|
      splitAddID = locator[35, locator.length()]
      lines_matcher = line.include? splitAddID
      if lines_matcher
        each_line_matcher = line.scan(str_pattern)
        if each_line_matcher
          getID_matcher = line.scan(/id="ctl[0-9]*_ctl[0-9]*_phContent_ctl[0-9]*_ctl[a-zA-z0-9]*"/)
          return getID_matcher
        else
          getID_matcher = line.scan(/id="ctl[a-zA-z0-9]*"/)
          return getID_matcher
        end
      end
    end

  end

  def getCodeError
    pageSource = @driver.page_source.to_s
    splitToNewline = pageSource.gsub(/\>/, ">\r\n")
    splitToNewline.each_line do |line|
      lines_matcher = line.include? "<code"
      #if lines_matcher
      assert_false(lines_matcher, 'Found Code Error or Server Page')
      #p 'found Code Error or Server Page'
      #end
    end
  end

  def getErrorBox
    # errorBox = @driver.find_element(:css => div.c1errordetails)
    #if element_present?(:css, 'div.c1errordetails') || element_present?(:css, 'span.c1error')
    #  true
    #end
    c1errordetail = element_present?(:css, 'div.c1errordetails')
    c1error = element_present?(:css, 'span.c1error')
    #if c1errordetail
    assert_false(c1errordetail, 'Found Code Error or Server Page')
    #elsif c1error
    assert_false(c1error, 'Found Code Error or Server Page')
    #end

  end

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

  # module Test::Unit::Assertions
  #   def assert_contains(expected_substring, string, *args)
  #     assert string.include?(expected_substring), *args
  #   end
  #
  #   def assert_false(object, message = '')
  #     assert_equal(false, object, message)
  #   end
  # end

  def assert_contains(expected_substring, string, *args)
    assert(string.include? expected_substring)
  end

  def assert_false(object, message = '')
    assert_equal(false, object, message)
  end

end