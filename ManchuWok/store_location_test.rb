# encoding: utf-8
require 'rubyXL'
require 'csv'
require 'rubygems'
require 'test/unit'
require 'selenium-webdriver'

class MyStore < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 10
    @verification_errors = []
    @baseURL = 'http://dev.manchuwok-wp.com/wp-admin'
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit()
  end

  # Fake test
  def test_fail

    fail('Not implemented')
  end

  def test_store_locator_import
    @driver.get(@baseURL)
    @driver.find_element(:id, 'user_login').send_keys 'admin'
    @driver.find_element(:id, 'user_pass').send_keys 'password'
    @driver.find_element(:id, 'wp-submit').click

    sleep 2

    @driver.get('http://dev.manchuwok-wp.com/wp-admin/admin.php?page=slp_manage_locations')

    @driver.find_element(:css, '#wpcsl-nav > ul > li:nth-child(2) > a').click

    data_import = CSV.read('C:\Users\nuttapon\Downloads\Store Directory.csv', :headers => true)
    data_import.each do |each_data|
      name = each_data['Name']
      street1 = each_data['Address']
      street2 = each_data['Address2']
      city = each_data['City']
      state = each_data['Prov']
      zip = each_data['Postal']
      country = each_data['Country']

      @driver.find_element(:id, 'edit-store-').send_keys name
      @driver.find_element(:id, 'edit-address-').send_keys street1
      @driver.find_element(:id, 'edit-address2-').send_keys street2
      @driver.find_element(:id, 'edit-city-').send_keys city
      @driver.find_element(:id, 'edit-state-').send_keys state
      @driver.find_element(:id, 'edit-zip-').send_keys zip
      @driver.find_element(:id, 'edit-country-').send_keys country

      @driver.find_element(:class, 'button-primary').click

      sleep 3

    end
  end


end