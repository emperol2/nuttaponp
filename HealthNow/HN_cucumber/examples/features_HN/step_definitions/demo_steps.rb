require 'selenium-webdriver'

Given(/^I open the website "(.*?)"$/) do |website|
  visit website
end
When(/^I enter username and password "(.*?)", "(.*?)"$/) do |username, password|
  fill_in 'txtUsername', :with => username
  fill_in 'txtPassword', :with => password
  find('.btn-login').click
end

Then(/^I should see a "(.*?)" page$/) do |expected_page|
  result_page = title
  result_page.should include expected_page
end

Then(/^the user profile should be "(.*?)"$/) do |expected_name|
  nameOnProfile = find('.info .name')
  nameOnProfile.has_text?(expected_name)
end