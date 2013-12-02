require 'rubygems'
require 'selenium-webdriver'

IEDriver_path = 'C:\Users\nuttapon\Downloads\IEDriverServer_Win32_2.33.0\IEDriverServer.exe'
BaseURL = "http://stylexchange2011.openface.com" #this can be changed to Live site
LayoutPathIE = "C:/LayoutDiff/LiveCapture/IE"

Selenium::WebDriver::IE.driver_path = IEDriver_path
driver = Selenium::WebDriver.for :ie
driver.manage.timeouts.implicit_wait = 200 # seconds
wait = Selenium::WebDriver::Wait.new(:timeout => 60) # seconds

#driver.get "http://search.yahoo.com/"
driver.navigate.to BaseURL
driver.manage.timeouts.implicit_wait= 10
driver.save_screenshot LayoutPathIE + "/homepage.png" #CaptureEntireScreen for Homepage
element = driver.find_element(:id => "search")
element.send_keys "Selenium Webdriver Step by Step"
element.submit
driver.save_screenshot LayoutPathIE + "/notfound.png" #CaptureEntireScreen for PageNotFound (Search)

driver.find_element(:css => 'html li.women span.widget a').click
driver.manage.timeouts.implicit_wait= 10
driver.save_screenshot LayoutPathIE + "/women.png" #CaptureEntireScreen for Women

driver.find_element(:css => 'html li.men span.widget a').click
driver.manage.timeouts.implicit_wait= 10
driver.save_screenshot LayoutPathIE + "/men.png" #CaptureEntireScreen for Men

driver.find_element(:css => 'html ul.products-grid li.item div.area h2.product-name a').click
driver.manage.timeouts.implicit_wait= 10
driver.save_screenshot LayoutPathIE + "/productDetail.png" #CaptureEntireScreen for Men


puts driver.title
driver.quit