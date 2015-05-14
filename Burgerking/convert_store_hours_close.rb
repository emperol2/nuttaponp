require 'csv'

class ConvertStoreHoursClose

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

    if mondayClose == (tuesdayClose && wednesdayClose && thursdayClose && fridayClose && saturdayClose)
      p "Rest: #{rest} - M-Sa: #{mondayClose}"

    elsif (mondayClose == (tuesdayClose && wednesdayClose && thursdayClose &&  fridayClose) && mondayClose != saturdayClose)

      p "Rest: #{rest} - M-F: #{mondayClose} and Sa: #{saturdayClose}"

    elsif (mondayClose == (tuesdayClose && wednesdayClose && thursdayClose) && (mondayClose != fridayClose && saturdayClose))

      p "Rest: #{rest} - M-Th: #{mondayClose} and Fr-Sa: #{fridayClose}"

     elsif mondayClose != (tuesdayClose && wednesdayClose && thursdayClose && fridayClose && saturdayClose) && tuesdayClose == (wednesdayClose && thursdayClose && fridayClose && saturdayClose)

       p "Rest: #{rest} - M: #{mondayClose} and Tu-Sa: #{tuesdayClose}"

    # elsif mondayOpen == (tuesdayOpen && wednesdayOpen && thursdayOpen && saturdayOpen) && mondayOpen != fridayOpen

      # p "Rest: #{rest} - M-Th: #{mondayOpen}, Fr: #{fridayOpen}, Sa: #{saturdayOpen}"

    else

      p "error"

    end



  end

end
