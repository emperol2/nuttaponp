#!/bin/env ruby
# encoding: utf-8

require 'test/unit'
require 'selenium-webdriver'

class TestNonEN < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Create Object from CPBI Library (cpbi_lib.rb)
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.window.maximize
    @base_url = 'https://216.46.31.242/Nexa/login.html'
    @driver.manage.timeouts.implicit_wait = 10
    @wait = Selenium::WebDriver::Wait.new :timeout => 20
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    @driver.quit()
    eval %q{ local_variables.each { |e| eval("#{e} = nil") } }
  end

  ###################################################################
  ################### FOR DLC SKIN ##################################
  ###################################################################

  def test_new_contact_DLC
    # To change this template use File | Settings | File Templates.
    @driver.navigate.to(@base_url)

    login()
    @driver.find_element(:link_text, 'Contacts').click
    @driver.find_element(:link_text, 'Add a New Contact').click

    getAllInputFields = @driver.find_elements(:tag_name, 'input')
    getAllInputFields.each_with_index do |x, index|
      #puts index
      if index >= 40 && index <= 72

        getType = x.attribute('type')
        getName = x.attribute('name')

        if getType == 'text' and (getName.include? '[' or getName.include? ']' or getName.include? 'end' or getName.include? 'stop' or getName.include? 'followUpReason' or getName.include? 'dailyOptionInterval') == false

          nonEn = ['ç', 'ÿ', 'ï', 'è', 'è', 'ç', 'ê', 'ô', 'ü', 'â', 'ñ']
          @randomNumber = Random.new()
          @randOneChar = (@randomNumber.rand * (nonEn.length - 1)).round
          puts @randOneChar
          @getChar = nonEn[@randOneChar]

          @attrName = x.attribute('name')

          if @attrName.include? 'start'
            puts 'has calendar'
          else
            @attrName = @attrName.split('.')
            @attrName = @attrName[1]
            @randOneNum = ((@randomNumber.rand * 200).round) + 1
            @concatStr = @attrName + ' test' + @randOneNum.to_s + ' ' + @getChar
            puts @concatStr
            x.send_keys @concatStr
          end
        end
      end

    end

    @driver.find_element(:id, 'addContactButton').click
    sleep 3

  end

  def test_new_application_DLC
    # To change this template use File | Settings | File Templates.
    @driver.navigate.to(@base_url)

    login()
    @driver.find_element(:link_text, 'Applications').click
    @driver.find_element(:link_text, 'Add New Application').click

    getAllInputFields = @driver.find_elements(:tag_name, 'input')
    getAllInputFields.each_with_index do |x, index|
      #puts index
      if index >= 47 && index <= 75

        getType = x.attribute('type')
        getName = x.attribute('name')

        if getType == 'text' and (getName.include? '[' or getName.include? ']' or getName.include? 'end' or getName.include? 'stop' or getName.include? 'followUpReason' or getName.include? 'dailyOptionInterval') == false

          nonEn = ['ç', 'ÿ', 'ï', 'è', 'è', 'ç', 'ê', 'ô', 'ü', 'â', 'ñ']
          @randomNumber = Random.new()
          @randOneChar = (@randomNumber.rand * (nonEn.length - 1)).round
          puts @randOneChar
          @getChar = nonEn[@randOneChar]

          @attrName = x.attribute('name')
          if @attrName.include? 'start'
            puts 'has calendar'
          elsif @attrName.include? 'applicationNumber'
            x.send_keys 'test'
          else
            @attrName = @attrName.split('.')
            @attrName = @attrName[1]
            @randOneNum = ((@randomNumber.rand * 200).round) + 1
            @concatStr = @attrName + ' test' + @randOneNum.to_s + ' ' + @getChar
            puts @concatStr
            x.send_keys @concatStr
          end

        elsif getName.include? 'applicationEntryDate'
          x.send_keys '03/17/2014'

        else
          # Do Nothing
        end

      end

    end

    @driver.find_element(:id, 'addApplicationButton').click
    sleep 5

    # Add Applicant
    @driver.find_element(:link_text, '+ Add Applicant').click
    @driver.find_element(:id, 'firstName').send_keys 'test'
    @driver.find_element(:id, 'searchButton').click
    @driver.find_element(:id, 'selectedContactId_0').click
    @driver.find_element(:id, 'nextButton').click

    # Select Applicant type
    select_obj = @driver.find_element(:id, 'applicant.listApplicantAsId')
    select_list = select_obj.find_elements(:tag_name, 'option')
    select_list.each do |option|
      if option.text == 'Co-Applicant'
        option.click
      end
    end

    @driver.find_element(:id, 'nextButton').click
    @driver.find_element(:id, 'addApplicationButton').click
    sleep 5

  end

  ###################################################################
  ################### FOR CRM SKIN ##################################
  ###################################################################

  def test_new_contact_CRM
    # To change this template use File | Settings | File Templates.
    @driver.navigate.to(@base_url)

    login_CRM()
    #@driver.find_element(:link_text, 'Contacts').click
    #@driver.find_element(:link_text, 'Add a New Contact').click
    @driver.navigate.to('https://216.46.31.242/Nexa/index.html?_flowId=viewContactApplicationPage-flow&_initialViewId=AddContact')

    getAllInputFields = @driver.find_elements(:tag_name, 'input')
    getAllInputFields.each_with_index do |x, index|
      #puts index
      if index >= 16 && index <= 47

        getType = x.attribute('type')
        getName = x.attribute('name')

        if getType == 'text' and (getName.include? '[' or getName.include? ']' or getName.include? 'end' or getName.include? 'stop' or getName.include? 'followUpReason' or getName.include? 'dailyOptionInterval') == false

          nonEn = ['ç', 'ÿ', 'ï', 'è', 'è', 'ç', 'ê', 'ô', 'ü', 'â', 'ñ']
          @randomNumber = Random.new()
          @randOneChar = (@randomNumber.rand * (nonEn.length - 1)).round
          puts @randOneChar
          @getChar = nonEn[@randOneChar]

          @attrName = x.attribute('name')

          if @attrName.include? 'start'
            puts 'has calendar'
          else
            @attrName = @attrName.split('.')
            @attrName = @attrName[1]
            @randOneNum = ((@randomNumber.rand * 200).round) + 1
            @concatStr = @attrName + ' test' + @randOneNum.to_s + ' ' + @getChar
            puts @concatStr
            x.send_keys @concatStr
          end
        end
      end

    end

    @driver.find_element(:id, 'addContactButton').click
    sleep 3

  end

  def test_new_Agent_CRM
    # To change this template use File | Settings | File Templates.
    @driver.navigate.to(@base_url)

    login_CRM()
    #@driver.find_element(:link_text, 'Contacts').click
    #@driver.find_element(:link_text, 'Add a New Contact').click
    @driver.navigate.to('https://216.46.31.242/Nexa/index.html?_flowId=manageContactCrm-flow&_initialViewId=AddContactCrm')

    getAllInputFields = @driver.find_elements(:tag_name, 'input')
    getAllInputFields.each_with_index do |x, index|
      #puts index
      if index >= 6

        getType = x.attribute('type')
        getName = x.attribute('name')

        if getType == 'text' and (getName.include? '[' or getName.include? ']' or getName.include? 'end' or getName.include? 'stop' or getName.include? 'followUpReason' or getName.include? 'dailyOptionInterval') == false

          nonEn = ['ç', 'ÿ', 'ï', 'è', 'è', 'ç', 'ê', 'ô', 'ü', 'â', 'ñ']
          @randomNumber = Random.new()
          @randOneChar = (@randomNumber.rand * (nonEn.length - 1)).round
          puts @randOneChar
          @getChar = nonEn[@randOneChar]

          @attrName = x.attribute('name')

          if @attrName.include? 'start'
            puts 'has calendar'
          else
            @attrName = @attrName.split('.')
            @attrName = @attrName[1]
            @randOneNum = ((@randomNumber.rand * 200).round) + 1
            @concatStr = @attrName + ' test' + @randOneNum.to_s + ' ' + @getChar
            puts @concatStr
            x.send_keys @concatStr
          end
        end
      end

    end

    @driver.find_element(:id, 'btnSave').click
    sleep 3

  end

  def test_new_application_CRM
    # To change this template use File | Settings | File Templates.
    @driver.navigate.to(@base_url)

    login_CRM()
    @driver.navigate.to('https://216.46.31.242/Nexa/index.html?_flowId=viewApplicationPage-flow&_initialViewId=AddApplication')

    getAllInputFields = @driver.find_elements(:tag_name, 'input')
    getAllInputFields.each_with_index do |x, index|
      #puts index
      if index >= 45 && index <= 70

        getType = x.attribute('type')
        getName = x.attribute('name')

        if getType == 'text' and (getName.include? '[' or getName.include? ']' or getName.include? 'end' or getName.include? 'stop' or getName.include? 'followUpReason' or getName.include? 'dailyOptionInterval') == false

          nonEn = ['ç', 'ÿ', 'ï', 'è', 'è', 'ç', 'ê', 'ô', 'ü', 'â', 'ñ']
          @randomNumber = Random.new()
          @randOneChar = (@randomNumber.rand * (nonEn.length - 1)).round
          puts @randOneChar
          @getChar = nonEn[@randOneChar]

          @attrName = x.attribute('name')
          if @attrName.include? 'start'
            puts 'has calendar'
          elsif @attrName.include? 'applicationNumber'
            x.send_keys 'test'
          else
            @attrName = @attrName.split('.')
            @attrName = @attrName[1]
            @randOneNum = ((@randomNumber.rand * 200).round) + 1
            @concatStr = @attrName + ' test' + @randOneNum.to_s + ' ' + @getChar
            puts @concatStr
            x.send_keys @concatStr
          end

        elsif getName.include? 'applicationEntryDate'
          x.send_keys '03/17/2014'

        else
          # Do Nothing
        end

      end

    end

    @driver.find_element(:id, 'addApplicationButton').click
    sleep 5

    # Add Applicant
    @driver.find_element(:link_text, '+ Add Applicant').click
    @driver.find_element(:id, 'firstName').send_keys 'test'
    @driver.find_element(:id, 'searchButton').click
    @driver.find_element(:id, 'selectedContactId_0').click
    @driver.find_element(:id, 'nextButton').click

    # Select Applicant type
    select_obj = @driver.find_element(:id, 'applicant.listApplicantAsId')
    select_list = select_obj.find_elements(:tag_name, 'option')
    select_list.each do |option|
      if option.text == 'Co-Applicant'
        option.click
      end
    end

    @driver.find_element(:id, 'nextButton').click
    @driver.find_element(:id, 'addApplicationButton').click
    sleep 5

  end

  def login
    @driver.find_element(:id, 'txtUsername').send_keys 'nuttapon'
    @driver.find_element(:id, 'txtPassword').send_keys '12345'
    @driver.find_element(:id, 'chkAgreeToTermsAndUse').click
    @driver.find_element(:xpath, '//*[@id="loginForm"]/table/tbody/tr[5]/td[2]/input').click
  end

  def login_CRM
    @driver.find_element(:id, 'txtUsername').send_keys 'kwan1'
    @driver.find_element(:id, 'txtPassword').send_keys 'kwan1'
    @driver.find_element(:id, 'chkAgreeToTermsAndUse').click
    @driver.find_element(:xpath, '//*[@id="loginForm"]/table/tbody/tr[5]/td[2]/input').click
  end

end