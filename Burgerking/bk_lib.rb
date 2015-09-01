require 'test/unit'
require 'minitest/test'

module BK_lib

  SITE_URL = 'http://origin:openface!@qa.burgerking.co.uk'
  LIVE_SITE = false
  GLOBALIZATION = true
  QA_USERNAME = 'origin'
  QA_PASSWORD = 'openface!'
  PRODUCT_SEARCH_TRUE = 'burger'
  PRODUCT_SEARCH_FALSE = 'aaaaaaaa'


  #which_BK('US')


  # def which_BK(siteURL)
  #   case siteURL
  #     when 'US'
  #       siteURL = 'http://bk.com'
  #     when 'UK'
  #       siteURL = 'http://burgerking.co.uk'
  #     else
  #       siteURL = 'http://bk.com'
  #   end
  # end

  def sharedModule
    p x = 1 + 1
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
    p ex
  end

  def verify_visible_image(how, what)
    imgList = @driver.find_elements(how, what)
    if imgList
      imgList.each do |i|
        begin
          if LIVE_SITE == true
            p i.attribute('src')
            res = Net::HTTP.get_response(URI(i.attribute('src')))
            just_verify { assert_equal('200', res.code, "This is error #{i.attribute('src')}") }
          else
            # p httpstring = i.attribute('src')
            req = Net::HTTP::Get.new(URI(i.attribute('src')))
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
     #     p e
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
      p urlString = imgListCSS.css_value('background-image')
      urlArray = urlString.split('(')
      url = urlArray[1].split(')')
      res = Net::HTTP.get_response(URI(url[0]))
      assert_equal('200', res.code, "This is error #{url[0]}")
    rescue Selenium::WebDriver::Error::NoSuchElementError
      p "Error #{what}"
    end
  end

end