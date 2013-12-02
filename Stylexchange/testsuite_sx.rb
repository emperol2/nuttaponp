require 'test/unit'
require 'test/unit/ui/console/testrunner'
require 'test/unit/testsuite'

#TestCase classes that contain the methods I want to execute
require '../Stylexchange/CheckLogin'

#create a new empty TestSuite, giving it a name
my_tests = Test::Unit::TestSuite.new('test')

#add the test method called 'test_one' defined
#in the TestOne TestCase class to the my_tests
#test suite defined above
my_tests << CheckLogin.new('CheckLogin')

#add the test method called 'test_me' defined
#in the TestTwo TestCase class to the my_tests
#test suite defined above

#run the suite
Test::Unit::UI::Console::TestRunner.run(my_tests)