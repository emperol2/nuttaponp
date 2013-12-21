require 'selenium-webdriver'
require 'rubygems'

class CPBI_backend
  # To change this template use File | Settings | File Templates.
  def initialize
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 15
    @wait = Selenium::WebDriver::Wait.new :timeout => 60
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
    @driver.get('http://icra-dev.openface.com/Composite/top.aspx')
    @wait.until {@driver.find_element(:css => 'input[name="username"]')}
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

  def manage_user
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

    select_iframeid()

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

  end

  def create_user
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

    select_iframeid()

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

end