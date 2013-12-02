require 'rubygems'
gem 'test-unit'
require 'test/unit'
require 'selenium-webdriver'

IEDriver_path = 'C:\Users\nuttapon\Downloads\IEDriverServer_Win32_2.33.0\IEDriverServer.exe'
BaseURL = "http://stylexchange2011.openface.com" #this can be changed to Live site
LayoutPathIE = "C:/LayoutDiff/LiveCapture/IE"

#Selenium::WebDriver::IE.driver_path = IEDriver_path
driver = Selenium::WebDriver.for :firefox
driver.manage.window.maximize
driver.manage.timeouts.implicit_wait = 10 # seconds
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

driver.get "http://www.stylexchange.com"
driver.navigate.to 'https://www.stylexchange.com/en/customer/account/login/'

username = driver.find_element(:xpath => '//input[@id="email"]')
username.send_keys 'xxxxx@gmail.com'
password = driver.find_element(:xpath => '//input[@id="pass"]')
password.send_keys '11111111'
button = driver.find_element(:xpath => '//button[@id="send2" and not(@disabled)]')
puts button
button.submit

#puts username
#puts password
# try to put the wrong username, correct password

puts 'incorrect username and password'

#test = Array.new
#test = driver.find_elements(:xpath => '//form[@class="sign-box"]').size

#puts "sign-up box #{test}"
=begin
test2 = driver.find_element(:xpath => '/html/body/div/div/div[3]/div/ul/li/div/form/fieldset/div').displayed?
puts "input login #{test2}"
=end
=begin
login = wait.until {
  element = driver.find_element(:xpath => '//input[@id="mini-login"]')
  element if element.displayed?
}
puts login
#driver.manage.timeouts.implicit_wait = 10
#driver.find_element(:xpath => '//input[@id="mini-login"]').click
if login != nil
  puts login
else
  puts "nil"
end
driver.manage.timeouts.implicit_wait = 10
=end
#element[0].send_keys "Selenium Webdriver Step by Step"
=begin
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
=end

#puts test


puts driver.title
driver.quit