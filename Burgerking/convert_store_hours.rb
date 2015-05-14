require 'csv'

class ConvertStoreHours

  data_import = CSV.read('C:/Users/nuttapon/Downloads/value.csv', :headers => true)

  data_import.each do |each_data|
    rest = each_data['Rest']
    sundayOpen = each_data['SundayOpen']
    sundayClose = each_data['SundayClose']
    mondayOpen = each_data['MondayOpen']
    mondayClose = each_data['MondayClose']
    tuesdayOpen = each_data['TuesdayOpen']
    tuesdayClose = each_data['TuesdayClose']
    wednesdayOpen = each_data['WednesdayOpen']
    wednesdayClose = each_data['WednesdayClose']
    thursdayOpen = each_data['ThursdayOpen']
    thursdayClose = each_data['ThursdayClose']
    fridayOpen = each_data['FridayOpen']
    fridayClose = each_data['FridayClose']
    saturdayOpen = each_data['SaturdayOpen']
    saturdayClose = each_data['SaturdayClose']

    if mondayOpen == (tuesdayOpen && wednesdayOpen && thursdayOpen && fridayOpen && saturdayOpen)
      p "Rest: #{rest} - M-Sa: #{mondayOpen}"

    elsif (mondayOpen == (tuesdayOpen && wednesdayOpen && thursdayOpen &&  fridayOpen) && mondayOpen != saturdayOpen)

      p "Rest: #{rest} - M-F: #{mondayOpen} and Sa: #{saturdayOpen}"

    elsif (mondayOpen == (tuesdayOpen && wednesdayOpen && thursdayOpen) && (mondayOpen != fridayOpen && saturdayOpen))

      p "Rest: #{rest} - M-Th: #{mondayOpen} and Fr-Sa: #{fridayOpen}"

    elsif mondayOpen != (tuesdayOpen && wednesdayOpen && thursdayOpen && fridayOpen && saturdayOpen) && tuesdayOpen == (wednesdayOpen && thursdayOpen && fridayOpen && saturdayOpen)

      p "Rest: #{rest} - M: #{mondayOpen} and Tu-Sa: #{tuesdayOpen}"

    elsif mondayOpen == (tuesdayOpen && wednesdayOpen && thursdayOpen && saturdayOpen) && mondayOpen != fridayOpen

      p "Rest: #{rest} - M-Th: #{mondayOpen}, Fr: #{fridayOpen}, Sa: #{saturdayOpen}"

    else

      p "error"

    end



  end

end
