# encoding: utf-8
require 'test/unit'
require 'selenium-webdriver'
require 'csv'

class ImportMenuItems < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new :timeout => 120
    @driver.manage.window.maximize
    @baseURL = "http://qa.burgerking.co.nz/user"
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
  end

  def test_importMenuItem
    @driver.get(@baseURL)
    admin_login(); sleep 3
    @driver.get("http://qa.burgerking.co.nz/node/add/food-menu-items")

    data_import = CSV.read('C:/Users/nuttapon/Documents/BK-NZ/MenuItems.csv', :headers => true, :encoding => 'iso-8859-1:UTF-8')

    data_import.each do |each_data|
      begin
        name = each_data['name']
        category = each_data['category']
        display_name = each_data['display_name']
        caption = each_data['caption']
        desc = each_data['desc']
        @item_type = each_data['item_type']
        @ingredient1 = each_data['ingredient1']
        @ingredient2 = each_data['ingredient2']
        @ingredient3 = each_data['ingredient3']
        @ingredient4 = each_data['ingredient4']
        @ingredient5 = each_data['ingredient5']
        #allergen = each_data['allergens']

        # Product name
        @driver.find_element(:id, 'edit-title').send_keys name

        # Category
        categories = category.split('-')
        categories.each do |x|
          case x
            when "1" # QA Test
              @driver.find_element(:id, 'edit-field-category-und-95').click
            when "2" # Value Menu
              @driver.find_element(:id, 'edit-field-category-und-8').click
            when "3" # Sweets
              @driver.find_element(:id, 'edit-field-category-und-7').click
            when "4" # Smoothies
              @driver.find_element(:id, 'edit-field-category-und-12').click
            when "5" # Sides
              @driver.find_element(:id, 'edit-field-category-und-6').click
            when "6" # Burgers
              @driver.find_element(:id, 'edit-field-category-und-1').click
            when "7" # Breakfast
              @driver.find_element(:id, 'edit-field-category-und-5').click
            when "8" # BEVERAGES
              @driver.find_element(:id, 'edit-field-category-und-4').click
            when "9" # CHICKEN & MORE
              @driver.find_element(:id, 'edit-field-category-und-2').click
            when "10" # KIDS MEALS
              @driver.find_element(:id, 'edit-field-category-und-11').click
            when "11" # SALADS & VEGGIES
              @driver.find_element(:id, 'edit-field-category-und-3').click
            when "12" # MAKE IT A MEAL -- This need more case
              @driver.find_element(:id, 'edit-field-category-und-4').click
            else
              puts "CATEGORY DOES NOT MATCH"
          end
        end

        # Product display name
        @driver.find_element(:id, 'edit-field-product-display-name-und-0-value').send_keys display_name

        # Caption
        @driver.find_element(:id, 'edit-field-caption-und-0-value').send_keys caption

        # Product description
        @driver.find_element(:id, 'edit-field-product-description-und-0-value').send_keys desc

        sleep 2
        @driver.execute_script('window.scrollBy(0,700)')

        # Menu item type
        if @item_type.eql? "0"
          @driver.find_element(:id, 'edit-field-menu-item-type-und-none').click
          sleep 2
        elsif @item_type.eql? "1"
          @driver.find_element(:id, 'edit-field-menu-item-type-und-40').click
          sleep 2
          insert_ingredients('1')
        elsif @item_type.eql? "2"
          @driver.find_element(:id, 'edit-field-menu-item-type-und-41').click
          sleep 2
          insert_ingredients('2')
        else
          puts "MENU ITEM TYPE DOES NOT MATCH"
        end

        # Allergens
        # allergens = allergen.split('-')
        # allergens.each do |x|
        #   case x
        #     when "1" # Coconut
        #       @driver.find_element(:id, 'edit-field-allergens-und-34').click
        #     when "2" # Egg
        #       @driver.find_element(:id, 'edit-field-allergens-und-35').click
        #     when "3" # Fish
        #       @driver.find_element(:id, 'edit-field-allergens-und-36').click
        #     when "4" # Milk
        #       @driver.find_element(:id, 'edit-field-allergens-und-37').click
        #     when "5" # Peanut
        #       @driver.find_element(:id, 'edit-field-allergens-und-46').click
        #     when "6" # Soy
        #       @driver.find_element(:id, 'edit-field-allergens-und-38').click
        #     when "7" # Tree Nut
        #       @driver.find_element(:id, 'edit-field-allergens-und-47').click
        #     when "8" # Wheat
        #       @driver.find_element(:id, 'edit-field-allergens-und-39').click
        #     else
        #       puts "ALLERGENS TYPE DOES NOT MATCH"
        #   end
        # end
        @driver.find_element(:id, 'edit-submit').click
        sleep 2
        @driver.get("http://qa.burgerking.co.nz/node/add/food-menu-items")
        sleep 2
        puts "#{name} is added properly to the system"

      rescue Exception => e # rescue if there any unexpected error
        puts e.message
        puts "#{name} is not added properly to the system"
        @driver.get("http://qa.burgerking.co.nz/node/add/food-menu-items")
        sleep 2
        next # go to next row
      end
    end

  end

  def admin_login
    # sleep 3
    # alert = @driver.switch_to.alert
    # alert.accept
    @driver.find_element(:id, "edit-name").send_keys 'Openface'
    @driver.find_element(:id, "edit-pass").send_keys 'buxaB4ha'
    @driver.find_element(:id, "edit-submit").click
  end

  def insert_ingredients(type)
    if type.eql? "1"
      type_id = 'ingredients'
    elsif type.eql? "2"
      type_id = 'variations'
    else
      puts "TYPE DOES NOT MATCH"
    end
    if @ingredient5.nil? == false
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys @ingredient1, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more").click
      @driver.execute_script('window.scrollBy(0,600)')
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys @ingredient2, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--2").click
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-2-target-id").send_keys @ingredient3, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-2-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-2-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--3").click
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-3-target-id").send_keys @ingredient4, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-3-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-3-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--4").click
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-4-target-id").send_keys @ingredient5, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-4-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-4-target-id").send_keys :enter
    elsif @ingredient4.nil? == false
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys @ingredient1, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more").click
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys @ingredient2, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--2").click
      @driver.execute_script('window.scrollBy(0,600)')
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-2-target-id").send_keys @ingredient3, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-2-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-2-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--3").click
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-3-target-id").send_keys @ingredient4, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-3-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-3-target-id").send_keys :enter
    elsif @ingredient3.nil? == false
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys @ingredient1, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more").click
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys @ingredient2, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--2").click
      @driver.execute_script('window.scrollBy(0,600)')
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-2-target-id").send_keys @ingredient3, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-2-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-2-target-id").send_keys :enter
    elsif @ingredient2.nil? == false
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys @ingredient1, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :enter
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-add-more").click
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys @ingredient2, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-1-target-id").send_keys :enter
      @driver.execute_script('window.scrollBy(0,600)')
    elsif @ingredient1.nil? == false
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys @ingredient1, :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :arrow_down
      sleep 2
      @driver.find_element(:id, "edit-field-#{type_id}-und-0-target-id").send_keys :enter
      @driver.execute_script('window.scrollBy(0,600)')
    end
  end

  # def check_ingredients
  #   (0..@nbofingredient-1).each do |y|
  #     sleep 2
  #     @driver.find_element(:id, "edit-field-#{type_id}-und-#{y.to_s}-target-id").send_keys @ingredient1, :arrow_down
  #     sleep 2
  #     @driver.find_element(:id, "edit-field-#{type_id}-und-#{y.to_s}-target-id").send_keys :arrow_down
  #     sleep 2
  #     @driver.find_element(:id, "edit-field-#{type_id}-und-#{y.to_s}-target-id").send_keys :enter
  #     sleep 2
  #     if y == 0
  #       @driver.find_element(:id, "edit-field-#{type_id}-und-add-more").click
  #     elsif y == 1
  #       @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--2").click
  #     elsif y == 2
  #       @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--3").click
  #     elsif y == 3
  #       @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--4").click
  #     elsif y == 4
  #       @driver.find_element(:id, "edit-field-#{type_id}-und-add-more--5").click
  #     else
  #       puts "Ingredients are limited by 5"
  #     end # check add more ingredients button
  #   end # number of ingredients from CSV
  # end # end method

end
