class ReadFrench
  # To change this template use File | Settings | File Templates.

  File.open('C:/for_test/Strings.fr.resx','r').each_with_index do |line, i|
    if line.include? '(fr)'
      File.open('C:/for_test/output.txt', 'a') do |f2|
        x = line.gsub('<value>(fr) ','')
        y = x.gsub('</value>', '')
        f2.puts y + "\n"
      end
    else
      ### DO NOTHING ###
      puts 'There is no "fr" contains in this line. ' + 'line# : ' + i.to_s
    end
  end

end