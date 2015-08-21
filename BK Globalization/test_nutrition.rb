require 'test/unit'
require 'selenium-webdriver'
require 'csv'
require 'phantomjs'

class TestNutrition < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 6000
    @driver = Selenium::WebDriver.for :phantomjs, :http_client => client
    @driver.manage.timeouts.implicit_wait = 60
    @wait = Selenium::WebDriver::Wait.new :timeout => 6000
    @driver.navigate.to('http://www.bk.com/menu/burgers')
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
  end

  def test_nutrition
    data_import = CSV.read('C:/Users/nuttapon/Downloads/BKNutrition.csv', :headers => true)
    data_import.each do |each_data|
      rest = each_data['NutritionFacts']
      calories = each_data['Calories']
      protein = each_data['Protein']
      carbohydrates = each_data['Carbohydrates']
      sugar = each_data['Sugar']
      fat = each_data['Fat']
      saturatedFat = each_data['SaturatedFat']
      transFat = each_data['TransFat']
      cholesterol = each_data['Cholesterol']
      sodium = each_data['Sodium']

      sleep 2

      @driver.navigate.to('http://www.bk.com/menu/burgers')

      itemsArray = Array.new
      nodeURL = 'http://www.bk.com/node/'
      findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
      findItemLinks.each do |f|
        itemsArray.push(nodeURL+f.attribute('data-product-id'))
      end

      itemsArray.uniq.each do |a|
        @driver.navigate.to(a)

        title = @driver.find_element(:css, '.title-group .title')
        percent_matched = string_difference_percent(title.text.downcase, rest.downcase)
        if percent_matched < 0.1
          p "product #{title.text.downcase} does match #{rest.downcase}"
          sleep 2

          getCalories = @driver.find_element(:css, 'li.calories .number')
          getProtein = @driver.find_element(:css, 'li.protein .number')
          getCarbohydrates = @driver.find_element(:css, 'li.carbohydrates .number')
          getSugar = @driver.find_element(:css, 'li.sugar .number')
          getFat = @driver.find_element(:css, 'li.fat .number')
          getSaturatedFat = @driver.find_element(:css, 'li.saturatedfat .number')
          getTransFat = @driver.find_element(:css, 'li.transfat .number')
          getCholesterol = @driver.find_element(:css, 'li.cholesterol .number')
          getSodium = @driver.find_element(:css, 'li.sodium .number')

          if getCalories.text != calories
            p 'calories does not match'
          elsif getProtein.text != protein
            p 'protein does not match'
          elsif getCarbohydrates.text != carbohydrates
            p 'carbohydrates does not match'
          elsif getSugar.text != sugar
            p 'sugar does not match'
          elsif getFat.text != fat
            p 'fat does not match'
          elsif getSaturatedFat.text != saturatedFat
            p 'saturatedFat does not match'
          elsif getTransFat.text != transFat
            p 'transFat does not match'
          elsif getCholesterol.text != cholesterol
            p 'cholesterol does not match'
          elsif getSodium.text != sodium
            p 'sodium does not match'
          else
            p "#{rest} is fine"
          end
        else
          #p "product #{title.text.downcase} did not match #{rest.downcase}"
        end


      end





    end

    # getCalories = getCalories.text
    # p "#{getCalories}"
    # p "#{calories}"
    # if getCalories == calories
    #   p 'matched'
    #   els
    #   p 'not matched'
    # end



    # ary = Array.new
    # itemsArray = Array.new
    # nodeURL = 'http://www.bk.com/node/'
    #
    # cagetoryList = @driver.find_elements(:css, '.food-category a')
    # cagetoryList.each do |c|
    #   ary.push(c.attribute('href'))
    # end
    #
    # ary.each do |aa|
    #   @driver.navigate.to(aa)
    #   findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
    #   findItemLinks.each do |f|
    #     itemsArray.push(nodeURL+f.attribute('data-product-id'))
    #   end
    # end
    #
    # itemsArray.uniq.each do |a|
    #   @driver.navigate.to(a)
    #   begin
    #     sleep 2
    #     @wait.until {@driver.find_element(:css, 'li.calories .number').displayed?}
    #     nutritionalList = @driver.find_elements(:css, 'li.calories .number')
    #     #p nutritionalList[0].text
    #     if nutritionalList[0].text.empty?
    #       p "No Table #{a}"
    #     end
    #       #assert_not_empty(nutritionalList[0].text)
    #   rescue Selenium::WebDriver::Error::TimeOutError
    #     p "TimeOutError #{a}"
    #     next
    #   end
    #
    #
    # end
  end

  def string_difference_percent(a, b)
    longer = [a.size, b.size].max
    same = a.each_char.zip(b.each_char).select { |a,b| a == b }.size
    (longer - same) / a.size.to_f
  end

end