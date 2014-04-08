require 'test/unit'
require_relative '../../HealthNow/WebDriver/HN_test.rb'
require 'selenium-webdriver'

class Provider < Test::Unit::TestCase

  def test_ProviderHome

    @HN = UI_frontEnd.new
    @HN_Setup = @HN.setup
    @HN.test_LogInAsProvider
    @driver = @HN.driver
    assert_equal('Patient List', @driver.title)
    @HN.teardown

  end


end