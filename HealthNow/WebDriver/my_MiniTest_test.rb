require 'minitest/unit'
require 'minitest/autorun'
require 'selenium-webdriver'
include MiniTest::Assertions

class MyMiniTest < MiniTest::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_plus
    a = 'test'
    a.wont_be :<=, 'x'

    assert(false, 'This should be true - Assert')
    refute(true, 'This should be true - Refute')

  end

  def test_that_will_be_skipped
    skip "test this later"
  end

end