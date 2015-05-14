require 'test/unit'
require 'selenium-webdriver'
require 'csv'

class ImportIngredientPortions < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new :timeout => 120
    @baseURL = "http://dev.burgerking.co.nz:8888/user"
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
  end

  def test_importIngredientPortions
    @driver.get(@baseURL)
    admin_login()
    sleep 3
    @driver.get("http://dev.burgerking.co.nz:8888/node/add/ingredient-portions")

    data_import = csv_import

    data_import.each do |each_data|
      begin
        title = each_data['title']
        weight = each_data['weight']
        cal = each_data['cal']
        protein = each_data['protein']
        carb = each_data['carb']
        sugar = each_data['sugar']
        fat = each_data['fat']
        sat_fat = each_data['sat_fat']
        trans_fat = each_data['trans_fat']
        chol = each_data['chol']
        sodium = each_data['sodium']
        fiber = each_data['fiber']

        @driver.find_element(:id, 'edit-title').send_keys title
        @driver.find_element(:id, 'edit-field-weight-und-0-value').send_keys weight
        @driver.find_element(:id, 'edit-field-calories-und-0-value').send_keys cal
        @driver.find_element(:id, 'edit-field-protein-und-0-value').send_keys protein
        @driver.find_element(:id, 'edit-field-carbohydrates-und-0-value').send_keys carb
        @driver.find_element(:id, 'edit-field-sugar-und-0-value').send_keys sugar
        @driver.find_element(:id, 'edit-field-fat-und-0-value').send_keys fat
        @driver.find_element(:id, 'edit-field-saturated-fat-und-0-value').send_keys sat_fat
        @driver.find_element(:id, 'edit-field-trans-fat-und-0-value').send_keys trans_fat
        @driver.find_element(:id, 'edit-field-cholesterol-und-0-value').send_keys chol
        @driver.find_element(:id, 'edit-field-sodium-und-0-value').send_keys sodium
        @driver.find_element(:id, 'edit-field-fiber-und-0-value').send_keys fiber

        @driver.find_element(:id, 'edit-submit').click
        sleep 2
        @driver.get("http://dev.burgerking.co.nz:8888/node/add/ingredient-portions")

      rescue
        next
      end
    end

  end

  def admin_login
    @driver.find_element(:id, "edit-name").send_keys 'Openface'
    @driver.find_element(:id, "edit-pass").send_keys 'buxaB4ha'
    @driver.find_element(:id, "edit-submit").click
  end

  def csv_import
    CSV.read('C:/Users/nuttapon/Documents/IngredientPortions.csv', :headers => true)
  end
end