require 'selenium-webdriver'
require 'page-object'

class LoginPage
  # To change this template use File | Settings | File Templates.
  include PageObject
  text_field(:username, :id => 'txtUsername')
  text_field(:password, :id => 'txtPassword')
  button(:login, :id => 'btnLogin')

end