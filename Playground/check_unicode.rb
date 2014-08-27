# encoding: utf-8
require 'rubyXL'
require 'rubygems'

class CheckUnicodeXLS
  workbook = RubyXL::Parser.parse('C:\Users\nuttapon\Downloads\PartialMemberDev.xlsx')
  worksheet = workbook[0]
  # p row = worksheet.extract_data[0].count
  worksheet.extract_data.each_index do |x|
    worksheet.extract_data[x].each_index do |y|
      # each_cell = worksheet.extract_data[x][y]
      if worksheet.extract_data[x][y] != nil
        blacklistChars = ['€', '™', 'â€']
        blacklistChars.any? do |blacklist|
          if worksheet.extract_data[x][y].to_s.include? blacklist
            #p each_cell
            File.open('C:\Users\nuttapon\Downloads\xxx.txt', 'a+') { |file| file.write(worksheet.extract_data[x][y]) }
          end
        end
      end
    end

  end

# p row = worksheet.extract_data[0][0]
# p row.scan"Member"
end