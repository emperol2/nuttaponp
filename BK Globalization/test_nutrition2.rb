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
    @driver.navigate.to('http://qa.burgerking.com.br/menu/')
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
    @driver.quit
  end

  def test_nutrition

    ary = Array.new
    itemsArray = Array.new
    nodeURL = 'http://qa.burgerking.fi/node/'

    cagetoryList = @driver.find_elements(:css, '.food-category a')
    cagetoryList.each do |c|
      ary.push(c.attribute('href'))
    end

    ary.each do |aa|
      @driver.navigate.to(aa)
      findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
      findItemLinks.each do |f|
        itemsArray.push(nodeURL+f.attribute('data-product-id'))
      end
    end

    # CSV.open('C:/Users/nuttapon/Downloads/BKNutrition.csv', "a+") do |csv|
    #   csv << ["NutritionFacts", "Calories", "Protein", "Carbohydrates", "Sugar", "Fat", "SaturatedFat", "TransFat", "Cholesterol", "Sodium"]

    CSV.open('C:/Users/nuttapon/Downloads/BKNutrition.csv', "a+") do |csv|
      csv << ["NutritionFacts", "Caption", "Description", "YouMay1", "YouMay2", "YouMay3"]

      itemsArray.uniq.each do |a|
        @driver.navigate.to(a)

        sleep 2

        begin
          title = @driver.find_element(:css, '.title-group .title')
          # getCalories = @driver.find_element(:css, 'li.calories .number')
          # getProtein = @driver.find_element(:css, 'li.protein .number')
          # getCarbohydrates = @driver.find_element(:css, 'li.carbohydrates .number')
          # getSugar = @driver.find_element(:css, 'li.sugar .number')
          # getFat = @driver.find_element(:css, 'li.fat .number')
          # getSaturatedFat = @driver.find_element(:css, 'li.saturatedfat .number')
          # getTransFat = @driver.find_element(:css, 'li.transfat .number')
          # getCholesterol = @driver.find_element(:css, 'li.cholesterol .number')
          # getSodium = @driver.find_element(:css, 'li.sodium .number')
          subtitle = @driver.find_element(:css, '.title-group .subtitle')
          description = @driver.find_element(:css, 'div.text-left p')
          youmay1 = @driver.find_element(:css, 'body > section > div > div:nth-child(2) > div > span')
          youmay2 = @driver.find_element(:css, 'body > section > div > div:nth-child(3) > div > span')
          youmay3 = @driver.find_element(:css, 'body > section > div > div:nth-child(4) > div > span')

          # csv << [title.text, getCalories.text, getProtein.text, getCarbohydrates.text, getSugar.text, getFat.text, getSaturatedFat.text, getTransFat.text, getCholesterol.text, getSodium.text]

          csv << [title.text, subtitle.text, description.text, youmay1.text, youmay2.text, youmay3.text]


        rescue NoMethodError
          p "Error - #{title}"
          next
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