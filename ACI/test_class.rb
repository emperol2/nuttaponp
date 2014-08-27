class TestClass

  def self.x
    p 'test x'
  end

  def y
    p 'test y'
  end

end

myclass = TestClass.new

p myclass
TestClass.x
myclass.y