require 'csv'

class StoreHoursConverter

  def am_pm(hour)
    meridian = (hour >= 12) ? 'pm' : 'am'
    hour = case hour
             when 0, 12
               12
             when 13 .. 23
               hour - 12
             else
               hour
           end

    "#{ hour } #{ meridian }"
  end

  def getSunday
    false
  end

end

@converter = StoreHoursConverter.new

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

  sunday = sundayOpen+sundayClose
  monday = mondayOpen+mondayClose
  tuesday = tuesdayOpen+tuesdayClose
  wednesday = wednesdayOpen+wednesdayClose
  thursday = thursdayOpen+thursdayClose
  friday = fridayOpen+fridayClose
  saturday = saturdayOpen+saturdayClose

  if @converter.getSunday
    p "S #{sundayOpen}-#{sundayClose}"

  else

    ### Monday - Saturday are the same ###
    if monday == (tuesday && wednesday && thursday && friday && saturday)
      # p "Rest: #{rest} -- M-Sa: #{mondayOpen} - #{mondayClose}"
      p "M-Sa #{mondayOpen}-#{mondayClose}"

      ### Monday is difference ###
    elsif tuesday == (wednesday && thursday && friday && saturday)
      # p "Rest: #{rest} -- M: #{mondayOpen} - #{mondayClose}, Tu-Sa: #{tuesdayOpen} - #{tuesdayClose}"
      p "M #{mondayOpen}-#{mondayClose}, Tu-Sa #{tuesdayOpen}-#{tuesdayClose}"

      ### Monday and Tuesday are difference ###
    elsif wednesday == (thursday && friday && saturday)
      # p "Rest: #{rest} -- M: #{mondayOpen} - #{mondayClose}, Tu: #{tuesdayOpen} - #{tuesdayClose}, W-Sa: #{wednesdayOpen} - #{wednesdayClose}"
      p "M #{mondayOpen}-#{mondayClose}, Tu #{tuesdayOpen}-#{tuesdayClose}, W-Sa #{wednesdayOpen}-#{wednesdayClose}"

      ### Thursday - Saturday are the same ###
    elsif thursday == (friday && saturday)
      # p "Rest: #{rest} -- Th-Sa: #{thursdayOpen} - #{thursdayClose}"

      ### Monday is different than Tuesday and Wednesday ###
      if monday != (tuesday && wednesday)
        # p "Rest: #{rest} -- M: #{mondayOpen} - #{mondayClose}, Tu-We: #{tuesdayOpen} - #{tuesdayClose}, Th-Sa: #{thursdayOpen} - #{thursdayClose}"
        p "M #{mondayOpen}-#{mondayClose}, Tu-We #{tuesdayOpen}-#{tuesdayClose}, Th-Sa #{thursdayOpen}-#{thursdayClose}"
        ### Consider Monday - Wednesday are the same, and Thursday and Saturday are the same
      else
        # p "Rest: #{rest} -- M-We: #{mondayOpen} - #{mondayClose}"
        p "M-We #{mondayOpen}-#{mondayClose}, Th-Sa #{thursdayOpen}-#{thursdayClose}"
      end

    elsif friday == saturday
      # p "Rest: #{rest} -- Fr-Sa: #{fridayOpen} - #{fridayClose}"
      if monday == (tuesday && wednesday && thursday)
        # p "Rest: #{rest} -- M-Th: #{mondayOpen} - #{mondayClose}"
        p "M-Th #{mondayOpen}-#{mondayClose}, Fr-Sa #{fridayOpen}-#{fridayClose}"
      else
        # p "Rest: #{rest} -- F: #{fridayOpen} - #{fridayClose}, Sa: #{saturdayOpen} - #{saturdayClose}"
        p "M-Th #{mondayOpen}-#{mondayClose}, Fr #{fridayOpen}-#{fridayClose}, Sa #{saturdayOpen}-#{saturdayClose}"
      end

    elsif saturday != (friday && thursday && wednesday && tuesday && monday)
      # p "Rest: #{rest} -- M-F: #{mondayOpen} - #{mondayClose}, Sa: #{saturdayOpen} - #{saturdayClose}"
      p "M-Fr #{mondayOpen}-#{mondayClose}, Sa #{saturdayOpen}-#{saturdayClose}"

    else

      p "ERROR! NOT FOUND THIS CASE"

    end

    # if sunday
    #   p "S #{sundayOpen}-#{sundayClose}"
    # end

  end

end


