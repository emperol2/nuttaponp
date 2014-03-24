Given(/^I open the website "(.*?)"$/) do |website|
  visit website
end

#Given(/^I am a Patient/) do
#  titlePage = title
#
#  if titlePage == 'Profile'
#    find('#btn-menu').click
#    find('#lnkLogout').click
#
#  elsif titlePage == 'Patient List'
#    find('#btn-menu').click
#    find('#lnkLogout').click
#  else
#    # Do nothing
#
#  end
#end

#When(/^I click on menu icon at top-right/) do
#  find('#btn-menu').click
#end

When(/^I enter username and password "(.*?)", "(.*?)"$/) do |username, password|
  fill_in 'txtUsername', :with => username
  fill_in 'txtPassword', :with => password
  find('.btn-login').click
end

Then(/^I should see a "(.*?)"$/) do |message|
  begin
    failLoginBox = find('.msg-cannot-login')
    if failLoginBox
      message.has_text?('invalid')
    else
      message.has_text?('valid')
    end
  rescue Capybara::ElementNotFound
    false
  end
end

#Then(/^I should see the logout link$/) do
#  has_link?('Logout')
#end
#
#Then(/^I click the logout link$/) do
#  find('#lnkLogout').click
#end


Then(/^the user type should be "(.*?)"$/) do |usertype|
  titlePage = title

  if usertype == 'Profile'
    titlePage.should include usertype
    find('#btn-menu').click
    find('#lnkLogout').click

  elsif usertype == 'Patient List'
    titlePage.should include usertype
    find('#btn-menu').click
    find('#lnkLogout').click
  else
    # Do nothing


  end
end