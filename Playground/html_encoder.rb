# encoding: UTF-8
require 'rubygems'
require 'htmlentities'

class HTMLEncoder

  line_num = 0
  text = File.open('C:\Users\nuttapon\Downloads\Food menu items-india.txt', 'r:UTF-8').read
  text.gsub!(/\r\n?/, "\n")
  coder = HTMLEntities.new
  text.each_line do |line|
    #puts "#{line_num += 1} #{line}"
    #puts "#{coder.encode(line, :named)}"
    output = File.open('C:\Users\nuttapon\Downloads\Food menu items-india2222.txt', "a+" )
    output << coder.encode(line, :named)
    output.close
  end

  # coder = HTMLEntities.new
  # string = "WHOPPER® -hampurilaisemme ainesosia ovat avotulella grillattu 113 gramman* naudanlihapihvi, mehukas tomaatti, tuore salaatti, kermainen majoneesi, rapeat maustekurkut ja sipuliviipaleet, kaikki pehmeällä seesaminsiemensämpylällä. *Perustuu esikypsennetyn pihvin painoon."
  # puts coder.encode(string, :named)

end