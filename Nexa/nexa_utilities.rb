require 'selenium-webdriver'

class NexaUtilities

  def loginAsNormalUser(driver)
    driver.find_element(:id, 'txtUsername').send_keys 'MMDL-GOODEM'
    driver.find_element(:id, 'txtPassword').send_keys 'GOODEMMMD5'
    # MMDL-GOODEM/ GOODEMMMD5
    #driver.find_element(:id, 'txtUsername').send_keys 'user'
    #driver.find_element(:id, 'txtPassword').send_keys 'patcharin'
    driver.find_element(:id, 'chkAgreeToTermsAndUse').click
    driver.find_element(:xpath, '//*[@id="loginForm"]/table/tbody/tr[5]/td[2]/input').click
  end

  def start_time
    Time.now
  end

  def stop_time
    Time.now
  end

  # def time_diff_milli(start, finish)
  #   (finish - start) * 1000.0
  # end

  def time_diff_milli(start, finish)
    (finish - start)
  end

end