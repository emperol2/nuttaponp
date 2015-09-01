module BK_lib

  SITE_URL = 'http://www.bk.com'
  LIVE_SITE = true
  GLOBALIZATION = false
  QA_USERNAME = 'origin'
  QA_PASSWORD = 'openface!'
  PRODUCT_SEARCH_TRUE = 'burger'
  PRODUCT_SEARCH_FALSE = 'aaaaaaaa'
  LOCATION_SEARCH_TRUE = 'Miami'
  LOCATION_SEARCH_FALSE = 'Bangkok'


  ##########################################################################################################

  def visibleProductImage?
    imgListHero = @driver.find_elements(:css, '.hero img')
    imgListYMAL = @driver.find_elements(:css, '.recommendations img')
    allImgList = imgListHero + imgListYMAL
    if imgListHero.size() == 1
      allImgList.each do |i|
        begin
          if LIVE_SITE == true
            res = Net::HTTP.get_response(URI(i.attribute('src')))
            just_verify { assert_equal('200', res.code, "This is error #{i.attribute('src')}") }
          else
            # p httpstring = i.attribute('src')
            req = Net::HTTP::Get.new(URI(i.attribute('src')).request_uri)
            req.basic_auth QA_USERNAME, QA_PASSWORD
            res = Net::HTTP.start(URI(i.attribute('src')).hostname, URI(i.attribute('src')).port) {|http|
              # p http.request(req)
              # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
            }
            #puts res.code
            just_verify { assert res.code.include?'200' }
          end
        rescue NoMethodError => e
          p "Error Exception: #{i.attribute('src')}"
          p e
          next
        end
      end
    else
      false
      p "Warning: Please check this URL #{@driver.current_url}"
    end
  end

  def just_verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError, Minitest::Assertion => ex
    #@verification_errors << ex
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

  def show_system_error_msg?
    assert element_present?(:css, '.system-message') == false, 'This ERROR should not be displayed'
  end

  def visible_image?
    imgList = @driver.find_elements(:tag_name, 'img')
    if imgList
      imgList.each do |i|
        begin
          if LIVE_SITE == true
            res = Net::HTTP.get_response(URI(i.attribute('src')))
            just_verify { assert_equal('200', res.code, "This is error #{i.attribute('src')}") }
          else
            # p httpstring = i.attribute('src')
            req = Net::HTTP::Get.new(URI(i.attribute('src')).request_uri)
            req.basic_auth QA_USERNAME, QA_PASSWORD
            res = Net::HTTP.start(URI(i.attribute('src')).hostname, URI(i.attribute('src')).port) {|http|
              # p http.request(req)
              # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
            }
            #puts res.code
            just_verify { assert res.code.include?'200' }
          end
        rescue NoMethodError => e
          p "Error Exception: #{i.attribute('src')}"
          p e
          next
        end
      end
    else
      false
      p "There is no image on this page #{@driver.current_url}"
    end
  end

  def verify_visible_image(how, what)
    imgList = @driver.find_elements(how, what)
    if imgList
      imgList.each do |i|
        begin
          if LIVE_SITE == true and GLOBALIZATION == true
            res = Net::HTTP.get_response(URI(i.attribute('src')))
            just_verify { assert_equal('200', res.code, "This is error #{i.attribute('src')}") }
          elsif LIVE_SITE == true and GLOBALIZATION == false
            res = Net::HTTP.get_response(URI(i.attribute('data-src')))
            just_verify { assert_equal('200', res.code, "This is error #{i.attribute('data-src')}") }
          elsif LIVE_SITE == false and GLOBALIZATION == true
            # p httpstring = i.attribute('src')
            req = Net::HTTP::Get.new(URI(i.attribute('src')).request_uri)
            req.basic_auth QA_USERNAME, QA_PASSWORD
            res = Net::HTTP.start(URI(i.attribute('src')).hostname, URI(i.attribute('src')).port) {|http|
              # p http.request(req)
              # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
            }
            #puts res.code
            just_verify { assert res.code.include?'200' }
          elsif LIVE_SITE == false and GLOBALIZATION == false
            # p httpstring = i.attribute('src')
            req = Net::HTTP::Get.new(URI(i.attribute('data-src')).request_uri)
            req.basic_auth QA_USERNAME, QA_PASSWORD
            res = Net::HTTP.start(URI(i.attribute('data-src')).hostname, URI(i.attribute('data-src')).port) {|http|
              # p http.request(req)
              # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
            }
            #puts res.code
            just_verify { assert res.code.include?'200' }
          else
            p "Out of condition"
          end
        rescue NoMethodError => e
          p "Error Exception: #{i.attribute('data-src')}"
          p e
          next
        end
      end
    else
      false
      p "There is no image on this page #{@driver.current_url}"
    end
  end

  def verify_visible_image_in_css(how, what)
    begin
      imgListCSS = @driver.find_element(how, what)
      #puts imgListCSS.css_value('background-image')
      urlString = imgListCSS.css_value('background-image')
      urlArray = urlString.split('(')
      url = urlArray[1].split(')')
      if LIVE_SITE == true
        res = Net::HTTP.get_response(URI(url[0]))
        just_verify {assert_equal('200', res.code, "This is error #{url[0]}")}
      else
        # p httpstring = i.attribute('src')
        req = Net::HTTP::Get.new(URI(url[0]).request_uri)
        req.basic_auth QA_USERNAME, QA_PASSWORD
        res = Net::HTTP.start(URI(url[0]).hostname, URI(url[0]).port) {|http|
          # p http.request(req)
          # assert_equal('200', http.request(req), "This is error #{i.attribute('src')}")
        }
        #puts res.code
        just_verify { assert res.code.include?'200' }
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError
      p "Error #{what}"
    end
  end

end