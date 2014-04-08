#require 'minitest/spec'
require 'selenium-webdriver'
# arranges for minitest to run (in an exit handler, so it runs last)
require 'minitest/autorun'
#require 'minitest/reporters'
require 'ci/reporter/rake/minitest_loader'
#require 'test/unit'
#require 'rspec'

class HelloWorld_test < MiniTest::Unit::TestCase

  def test_add
    s = 4 + 1
    assert_equal(5, s)
  end

end